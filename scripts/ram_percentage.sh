#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

ram_percentage_format="%3.1f%%"

print_ram_percentage() {
  ram_percentage_format=$(get_tmux_option "@ram_percentage_format" "$ram_percentage_format")

  if command_exists "free"; then
    IFS=' ' read -ra numbers <<< "$(free | sed '/^\s*$/d' | grep "Mem:" | tr -s ' ' )"
    ram=$(bc <<< "scale=6; 100 * ${numbers[2]} / ${numbers[1]}" | awk -v format="$ram_percentage_format" '{usage=$1} END {printf(format,usage)}')
    echo "$ram" # I get an extra percent if I don't use the variable for some reason
  fi
}

main() {
  print_ram_percentage
}
main
