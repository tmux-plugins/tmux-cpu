#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

ram_low_fg_color=""
ram_medium_fg_color=""
ram_high_fg_color=""

ram_low_default_fg_color="#[fg=green]"
ram_medium_default_fg_color="#[fg=yellow]"
ram_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  ram_low_fg_color=$(get_tmux_option "@ram_low_fg_color" "$ram_low_default_fg_color")
  ram_medium_fg_color=$(get_tmux_option "@ram_medium_fg_color" "$ram_medium_default_fg_color")
  ram_high_fg_color=$(get_tmux_option "@ram_high_fg_color" "$ram_high_default_fg_color")
}

print_fg_color() {
  local ram_percentage
  local ram_load_status
  ram_percentage=$("$CURRENT_DIR"/ram_percentage.sh | sed -e 's/%//')
  ram_load_status=$(load_status "$ram_percentage" "ram")
  if [ "$ram_load_status" == "low" ]; then
    echo "$ram_low_fg_color"
  elif [ "$ram_load_status" == "medium" ]; then
    echo "$ram_medium_fg_color"
  elif [ "$ram_load_status" == "high" ]; then
    echo "$ram_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main
