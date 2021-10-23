#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

ram_low_bg_color=""
ram_medium_bg_color=""
ram_high_bg_color=""

ram_low_default_bg_color="#[bg=green]"
ram_medium_default_bg_color="#[bg=yellow]"
ram_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
  ram_low_bg_color=$(get_tmux_option "@ram_low_bg_color" "$ram_low_default_bg_color")
  ram_medium_bg_color=$(get_tmux_option "@ram_medium_bg_color" "$ram_medium_default_bg_color")
  ram_high_bg_color=$(get_tmux_option "@ram_high_bg_color" "$ram_high_default_bg_color")
}

print_bg_color() {
  local ram_percentage
  local ram_load_status
  ram_percentage=$("$CURRENT_DIR"/ram_percentage.sh | sed -e 's/%//')
  ram_load_status=$(load_status "$ram_percentage" "ram")
  if [ "$ram_load_status" == "low" ]; then
    echo "$ram_low_bg_color"
  elif [ "$ram_load_status" == "medium" ]; then
    echo "$ram_medium_bg_color"
  elif [ "$ram_load_status" == "high" ]; then
    echo "$ram_high_bg_color"
  fi
}

main() {
  get_bg_color_settings
  print_bg_color
}
main
