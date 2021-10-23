#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

# script global variables
gpu_temp_low_icon=""
gpu_temp_medium_icon=""
gpu_temp_high_icon=""

gpu_temp_low_default_icon="="
gpu_temp_medium_default_icon="≡"
gpu_temp_high_default_icon="≣"

# icons are set as script global variables
get_icon_settings() {
  gpu_temp_low_icon=$(get_tmux_option "@gpu_temp_low_icon" "$gpu_temp_low_default_icon")
  gpu_temp_medium_icon=$(get_tmux_option "@gpu_temp_medium_icon" "$gpu_temp_medium_default_icon")
  gpu_temp_high_icon=$(get_tmux_option "@gpu_temp_high_icon" "$gpu_temp_high_default_icon")
}

print_icon() {
  local gpu_temp
  local gpu_temp_status
  gpu_temp=$("$CURRENT_DIR"/gpu_temp.sh | sed -e 's/[^0-9.]//')
  gpu_temp_status=$(temp_status "$gpu_temp")
  if [ "$gpu_temp_status" == "low" ]; then
    echo "$gpu_temp_low_icon"
  elif [ "$gpu_temp_status" == "medium" ]; then
    echo "$gpu_temp_medium_icon"
  elif [ "$gpu_temp_status" == "high" ]; then
    echo "$gpu_temp_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main "$@"
