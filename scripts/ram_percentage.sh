#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

ram_percentage_format="%3.1f%%"

# macos vm_stat sample
# Mach Virtual Memory Statistics: (page size of 4096 bytes)
# Pages free:                               91122.
# Pages active:                           1492064.
# Pages inactive:                         1471069.
# Pages speculative:                        25487.
# Pages throttled:                              0.
# Pages wired down:                        866263.
# Pages purgeable:                         106819.
# "Translation faults":                 757779378.
# Pages copy-on-write:                   88220937.
# Pages zero filled:                    286952409.
# Pages reactivated:                       535355.
# Pages purged:                           1462986.
# File-backed pages:                       710060.
# Anonymous pages:                        2278560.
# Pages stored in compressor:              612786.
# Pages occupied by compressor:            248063.
# Decompressions:                         1400918.
# Compressions:                           2034985.
# Pageins:                                5227063.
# Pageouts:                                  1998.
# Swapins:                                1319876.
# Swapouts:                               1402641.

sum_macos_vm_stats() {
  cat - \
  | perl -pe "s/^[^\d]*([\d]*)\./\1/g"  \
  | awk '{ print $1 * 4096 }' \
  | awk '{ a += $1 } END { print a }' 
}

print_ram_percentage() {
  ram_percentage_format=$(get_tmux_option "@ram_percentage_format" "$ram_percentage_format")

  if command_exists "free"; then
    free | awk -v format="$ram_percentage_format" '$1 == "Mem:" {printf(format, 100*$3/$2)}'
  elif command_exists "vm_stat"; then
    # page size of 4096 bytes
    stats=$(vm_stat)

    used_and_cached=$(echo "$stats" \
      | grep -E "(Pages active|Pages inactive|Pages speculative|Pages wired down|Pages occupied by compressor)" \
      | sum_macos_vm_stats \
    )

    cached=$(echo "$stats" \
      | grep -E "(Pages purgeable|File-backed pages)" \
      | sum_macos_vm_stats \
    )

    free=$(echo "$stats" \
      | grep -E "(Pages free)" \
      | sum_macos_vm_stats \
    )

    used=$(($used_and_cached - $cached))
    total=$(($used_and_cached + $free))

    echo "$used $total" | awk -v format="$ram_percentage_format" '{printf(format, 100*$1/$2)}'
  fi
}

main() {
  print_ram_percentage
}
main
