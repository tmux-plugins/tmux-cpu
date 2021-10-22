#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gpu_temp_low_bg_color=""
gpu_temp_medium_bg_color=""
gpu_temp_high_bg_color=""

gpu_temp_low_default_bg_color="#[bg=green]"
gpu_temp_medium_default_bg_color="#[bg=yellow]"
gpu_temp_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
  gpu_temp_low_bg_color=$(get_tmux_option "@gpu_temp_low_bg_color" "$gpu_temp_low_default_bg_color")
  gpu_temp_medium_bg_color=$(get_tmux_option "@gpu_temp_medium_bg_color" "$gpu_temp_medium_default_bg_color")
  gpu_temp_high_bg_color=$(get_tmux_option "@gpu_temp_high_bg_color" "$gpu_temp_high_default_bg_color")
}

print_bg_color() {
  local gpu_temp
  local gpu_temp_status
  gpu_temp=$("$CURRENT_DIR"/gpu_temp.sh | sed -e 's/[^0-9.]//')
  gpu_temp_status=$(temp_status "$gpu_temp")
  if [ "$gpu_temp_status" == "low" ]; then
    echo "$gpu_temp_low_bg_color"
  elif [ "$gpu_temp_status" == "medium" ]; then
    echo "$gpu_temp_medium_bg_color"
  elif [ "$gpu_temp_status" == "high" ]; then
    echo "$gpu_temp_high_bg_color"
  fi
}

main() {
  get_bg_color_settings
  print_bg_color
}
main "$@"
