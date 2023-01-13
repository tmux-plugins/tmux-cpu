#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
swap_low_icon=""
swap_medium_icon=""
swap_high_icon=""

swap_low_default_icon="="
swap_medium_default_icon="≡"
swap_high_default_icon="≣"

# icons are set as script global variables
get_icon_settings() {
  swap_low_icon=$(get_tmux_option "@swap_low_icon" "$swap_low_default_icon")
  swap_medium_icon=$(get_tmux_option "@swap_medium_icon" "$swap_medium_default_icon")
  swap_high_icon=$(get_tmux_option "@swap_high_icon" "$swap_high_default_icon")
}

print_icon() {
  local swap_percentage=$($CURRENT_DIR/swap_percentage.sh | sed -e 's/%//')
  local load_status=$(load_status $swap_percentage)
  if [ $load_status == "low" ]; then
    echo "$swap_low_icon"
  elif [ $load_status == "medium" ]; then
    echo "$swap_medium_icon"
  elif [ $load_status == "high" ]; then
    echo "$swap_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main
