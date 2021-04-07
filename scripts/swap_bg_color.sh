#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

swap_low_bg_color=""
swap_medium_bg_color=""
swap_high_bg_color=""

swap_low_default_bg_color="#[bg=green]"
swap_medium_default_bg_color="#[bg=yellow]"
swap_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
  swap_low_bg_color=$(get_tmux_option "@swap_low_bg_color" "$swap_low_default_bg_color")
  swap_medium_bg_color=$(get_tmux_option "@swap_medium_bg_color" "$swap_medium_default_bg_color")
  swap_high_bg_color=$(get_tmux_option "@swap_high_bg_color" "$swap_high_default_bg_color")
}

print_bg_color() {
  local swap_percentage=$($CURRENT_DIR/swap_percentage.sh | sed -e 's/%//')
  local load_status=$(load_status $swap_percentage)
  if [ $load_status == "low" ]; then
    echo "$swap_low_bg_color"
  elif [ $load_status == "medium" ]; then
    echo "$swap_medium_bg_color"
  elif [ $load_status == "high" ]; then
    echo "$swap_high_bg_color"
  fi
}

main() {
  get_bg_color_settings
  print_bg_color
}
main
