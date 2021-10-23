#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gpu_low_bg_color=""
gpu_medium_bg_color=""
gpu_high_bg_color=""

gpu_low_default_bg_color="#[bg=green]"
gpu_medium_default_bg_color="#[bg=yellow]"
gpu_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
  gpu_low_bg_color=$(get_tmux_option "@gpu_low_bg_color" "$gpu_low_default_bg_color")
  gpu_medium_bg_color=$(get_tmux_option "@gpu_medium_bg_color" "$gpu_medium_default_bg_color")
  gpu_high_bg_color=$(get_tmux_option "@gpu_high_bg_color" "$gpu_high_default_bg_color")
}

print_bg_color() {
  local gpu_percentage
  local gpu_load_status
  gpu_percentage=$("$CURRENT_DIR"/gpu_percentage.sh | sed -e 's/%//')
  gpu_load_status=$(load_status "$gpu_percentage" "gpu")
  if [ "$gpu_load_status" == "low" ]; then
    echo "$gpu_low_bg_color"
  elif [ "$gpu_load_status" == "medium" ]; then
    echo "$gpu_medium_bg_color"
  elif [ "$gpu_load_status" == "high" ]; then
    echo "$gpu_high_bg_color"
  fi
}

main() {
  get_bg_color_settings
  print_bg_color
}
main "$@"
