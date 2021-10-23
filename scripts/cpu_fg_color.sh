#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

cpu_low_fg_color=""
cpu_medium_fg_color=""
cpu_high_fg_color=""

cpu_low_default_fg_color="#[fg=green]"
cpu_medium_default_fg_color="#[fg=yellow]"
cpu_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  cpu_low_fg_color=$(get_tmux_option "@cpu_low_fg_color" "$cpu_low_default_fg_color")
  cpu_medium_fg_color=$(get_tmux_option "@cpu_medium_fg_color" "$cpu_medium_default_fg_color")
  cpu_high_fg_color=$(get_tmux_option "@cpu_high_fg_color" "$cpu_high_default_fg_color")
}

print_fg_color() {
  local cpu_percentage
  local load_status
  cpu_percentage=$("$CURRENT_DIR"/cpu_percentage.sh | sed -e 's/%//')
  load_status=$(load_status "$cpu_percentage" "cpu")
  if [ "$load_status" == "low" ]; then
    echo "$cpu_low_fg_color"
  elif [ "$load_status" == "medium" ]; then
    echo "$cpu_medium_fg_color"
  elif [ "$load_status" == "high" ]; then
    echo "$cpu_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main "$@"
