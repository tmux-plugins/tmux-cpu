#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

# script global variables
ram_low_icon=""
ram_medium_icon=""
ram_high_icon=""

ram_low_default_icon="="
ram_medium_default_icon="≡"
ram_high_default_icon="≣"

# icons are set as script global variables
get_icon_settings() {
  ram_low_icon=$(get_tmux_option "@ram_low_icon" "$ram_low_default_icon")
  ram_medium_icon=$(get_tmux_option "@ram_medium_icon" "$ram_medium_default_icon")
  ram_high_icon=$(get_tmux_option "@ram_high_icon" "$ram_high_default_icon")
}

print_icon() {
  local ram_percentage
  local ram_load_status
  ram_percentage=$("$CURRENT_DIR"/ram_percentage.sh | sed -e 's/%//')
  ram_load_status=$(load_status "$ram_percentage" "ram")
  if [ "$ram_load_status" == "low" ]; then
    echo "$ram_low_icon"
  elif [ "$ram_load_status" == "medium" ]; then
    echo "$ram_medium_icon"
  elif [ "$ram_load_status" == "high" ]; then
    echo "$ram_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main "$@"
