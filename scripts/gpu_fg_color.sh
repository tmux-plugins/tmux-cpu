#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gpu_low_fg_color=""
gpu_medium_fg_color=""
gpu_high_fg_color=""

gpu_low_default_fg_color="#[fg=green]"
gpu_medium_default_fg_color="#[fg=yellow]"
gpu_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  gpu_low_fg_color=$(get_tmux_option "@gpu_low_fg_color" "$gpu_low_default_fg_color")
  gpu_medium_fg_color=$(get_tmux_option "@gpu_medium_fg_color" "$gpu_medium_default_fg_color")
  gpu_high_fg_color=$(get_tmux_option "@gpu_high_fg_color" "$gpu_high_default_fg_color")
}

print_fg_color() {
  local gpu_percentage
  local gpu_load_status
  gpu_percentage=$("$CURRENT_DIR"/gpu_percentage.sh | sed -e 's/%//')
  gpu_load_status=$(load_status "$gpu_percentage" "gpu")
  if [ "$gpu_load_status" == "low" ]; then
    echo "$gpu_low_fg_color"
  elif [ "$gpu_load_status" == "medium" ]; then
    echo "$gpu_medium_fg_color"
  elif [ "$gpu_load_status" == "high" ]; then
    echo "$gpu_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main "$@"
