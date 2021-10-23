#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

cpu_temp_low_bg_color=""
cpu_temp_medium_bg_color=""
cpu_temp_high_bg_color=""

cpu_temp_low_default_bg_color="#[bg=green]"
cpu_temp_medium_default_bg_color="#[bg=yellow]"
cpu_temp_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
  cpu_temp_low_bg_color=$(get_tmux_option "@cpu_temp_low_bg_color" "$cpu_temp_low_default_bg_color")
  cpu_temp_medium_bg_color=$(get_tmux_option "@cpu_temp_medium_bg_color" "$cpu_temp_medium_default_bg_color")
  cpu_temp_high_bg_color=$(get_tmux_option "@cpu_temp_high_bg_color" "$cpu_temp_high_default_bg_color")
}

print_bg_color() {
  local cpu_temp
  local cpu_temp_status
  cpu_temp=$("$CURRENT_DIR"/cpu_temp.sh | sed -e 's/[^0-9.]//')
  cpu_temp_status=$(temp_status "$cpu_temp")
  if [ "$cpu_temp_status" == "low" ]; then
    echo "$cpu_temp_low_bg_color"
  elif [ "$cpu_temp_status" == "medium" ]; then
    echo "$cpu_temp_medium_bg_color"
  elif [ "$cpu_temp_status" == "high" ]; then
    echo "$cpu_temp_high_bg_color"
  fi
}

main() {
  get_bg_color_settings
  print_bg_color
}
main
