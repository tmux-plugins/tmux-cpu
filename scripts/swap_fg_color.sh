#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

swap_low_fg_color=""
swap_medium_fg_color=""
swap_high_fg_color=""

swap_low_default_fg_color="#[fg=green]"
swap_medium_default_fg_color="#[fg=yellow]"
swap_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  swap_low_fg_color=$(get_tmux_option "@swap_low_fg_color" "$swap_low_default_fg_color")
  swap_medium_fg_color=$(get_tmux_option "@swap_medium_fg_color" "$swap_medium_default_fg_color")
  swap_high_fg_color=$(get_tmux_option "@swap_high_fg_color" "$swap_high_default_fg_color")
}

print_fg_color() {
  local swap_percentage=$($CURRENT_DIR/swap_percentage.sh | sed -e 's/%//')
  local load_status=$(load_status $swap_percentage)
  if [ $load_status == "low" ]; then
    echo "$swap_low_fg_color"
  elif [ $load_status == "medium" ]; then
    echo "$swap_medium_fg_color"
  elif [ $load_status == "high" ]; then
    echo "$swap_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main
