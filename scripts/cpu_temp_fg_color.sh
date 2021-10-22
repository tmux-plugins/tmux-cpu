#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

cpu_temp_low_fg_color=""
cpu_temp_medium_fg_color=""
cpu_temp_high_fg_color=""

cpu_temp_low_default_fg_color="#[fg=green]"
cpu_temp_medium_default_fg_color="#[fg=yellow]"
cpu_temp_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  cpu_temp_low_fg_color=$(get_tmux_option "@cpu_temp_low_fg_color" "$cpu_temp_low_default_fg_color")
  cpu_temp_medium_fg_color=$(get_tmux_option "@cpu_temp_medium_fg_color" "$cpu_temp_medium_default_fg_color")
  cpu_temp_high_fg_color=$(get_tmux_option "@cpu_temp_high_fg_color" "$cpu_temp_high_default_fg_color")
}

print_fg_color() {
  local cpu_temp
  local cpu_temp_status
  cpu_temp=$("$CURRENT_DIR"/cpu_temp.sh | sed -e 's/[^0-9.]//')
  cpu_temp_status=$(temp_status "$cpu_temp")
  if [ "$cpu_temp_status" == "low" ]; then
    echo "$cpu_temp_low_fg_color"
  elif [ "$cpu_temp_status" == "medium" ]; then
    echo "$cpu_temp_medium_fg_color"
  elif [ "$cpu_temp_status" == "high" ]; then
    echo "$cpu_temp_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main
