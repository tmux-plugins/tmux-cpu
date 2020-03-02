#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

ram_percentage_format="%3.1f%%"

print_ram_percentage() {
  ram_percentage_format=$(get_tmux_option "@ram_percentage_format" "$ram_percentage_format")

  if command_exists "free"; then
    free | awk -v format="$ram_percentage_format" '$1 == "Mem:" {printf(format, 100*$3/$2)}'
  fi
}

main() {
  print_ram_percentage
}
main
