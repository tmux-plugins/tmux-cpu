#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

# script global variables
cpu_low_icon=""
cpu_medium_icon=""
cpu_high_icon=""

cpu_low_default_icon="="
cpu_medium_default_icon="≡"
cpu_high_default_icon="≣"

# icons are set as script global variables
get_icon_settings() {
  cpu_low_icon=$(get_tmux_option "@cpu_low_icon" "$cpu_low_default_icon")
  cpu_medium_icon=$(get_tmux_option "@cpu_medium_icon" "$cpu_medium_default_icon")
  cpu_high_icon=$(get_tmux_option "@cpu_high_icon" "$cpu_high_default_icon")
}

print_icon() {
  local cpu_percentage
  local load_status
  cpu_percentage=$("$CURRENT_DIR"/cpu_percentage.sh | sed -e 's/%//')
  load_status=$(load_status "$cpu_percentage" "cpu")
  if [ "$load_status" == "low" ]; then
    echo "$cpu_low_icon"
  elif [ "$load_status" == "medium" ]; then
    echo "$cpu_medium_icon"
  elif [ "$load_status" == "high" ]; then
    echo "$cpu_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main "$@"
