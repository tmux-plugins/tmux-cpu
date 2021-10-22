#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gpu_temp_low_fg_color=""
gpu_temp_medium_fg_color=""
gpu_temp_high_fg_color=""

gpu_temp_low_default_fg_color="#[fg=green]"
gpu_temp_medium_default_fg_color="#[fg=yellow]"
gpu_temp_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  gpu_temp_low_fg_color=$(get_tmux_option "@gpu_temp_low_fg_color" "$gpu_temp_low_default_fg_color")
  gpu_temp_medium_fg_color=$(get_tmux_option "@gpu_temp_medium_fg_color" "$gpu_temp_medium_default_fg_color")
  gpu_temp_high_fg_color=$(get_tmux_option "@gpu_temp_high_fg_color" "$gpu_temp_high_default_fg_color")
}

print_fg_color() {
  local gpu_temp
  local gpu_temp_status
  gpu_temp=$("$CURRENT_DIR"/gpu_temp.sh | sed -e 's/[^0-9.]//')
  gpu_temp_status=$(temp_status "$gpu_temp")
  if [ "$gpu_temp_status" == "low" ]; then
    echo "$gpu_temp_low_fg_color"
  elif [ "$gpu_temp_status" == "medium" ]; then
    echo "$gpu_temp_medium_fg_color"
  elif [ "$gpu_temp_status" == "high" ]; then
    echo "$gpu_temp_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main "$@"
