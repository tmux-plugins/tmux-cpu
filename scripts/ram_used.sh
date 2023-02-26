#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

ram_used_format="%2.1fG"

sum_macos_vm_stats() {
  grep -Eo '[0-9]+' |
    awk '{ a += $1 * 4096 } END { print a }'
}

print_ram_used() {
  ram_used_format=$(get_tmux_option "@ram_used_format" "$ram_used_format")

  if command_exists "free"; then
    cached_eval free | awk -v format="$ram_used_format" '$1 ~ /Mem/ {printf(format, $3/1073741824)}'
  elif command_exists "vm_stat"; then
    # page size of 4096 bytes
    stats="$(cached_eval vm_stat)"

    used_and_cached=$(
      echo "$stats" |
        grep -E "(Pages active|Pages inactive|Pages speculative|Pages wired down|Pages occupied by compressor)" |
        sum_macos_vm_stats
    )

    cached=$(
      echo "$stats" |
        grep -E "(Pages purgeable|File-backed pages)" |
        sum_macos_vm_stats
    )

    used=$((used_and_cached - cached))

    echo "$used" | awk -v format="$ram_used_format" '{printf(format, $1/1073741824)}'
  fi
}

main() {
  print_ram_used
}
main
