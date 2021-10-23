#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

# script global variables
cpu_temp_low_icon=""
cpu_temp_medium_icon=""
cpu_temp_high_icon=""

cpu_temp_low_default_icon="="
cpu_temp_medium_default_icon="≡"
cpu_temp_high_default_icon="≣"

# icons are set as script global variables
get_icon_settings() {
  cpu_temp_low_icon=$(get_tmux_option "@cpu_temp_low_icon" "$cpu_temp_low_default_icon")
  cpu_temp_medium_icon=$(get_tmux_option "@cpu_temp_medium_icon" "$cpu_temp_medium_default_icon")
  cpu_temp_high_icon=$(get_tmux_option "@cpu_temp_high_icon" "$cpu_temp_high_default_icon")
}

print_icon() {
  local cpu_temp
  local cpu_temp_status
  cpu_temp=$("$CURRENT_DIR"/cpu_temp.sh | sed -e 's/[^0-9.]//')
  cpu_temp_status=$(temp_status "$cpu_temp")
  if [ "$cpu_temp_status" == "low" ]; then
    echo "$cpu_temp_low_icon"
  elif [ "$cpu_temp_status" == "medium" ]; then
    echo "$cpu_temp_medium_icon"
  elif [ "$cpu_temp_status" == "high" ]; then
    echo "$cpu_temp_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main "$@"
