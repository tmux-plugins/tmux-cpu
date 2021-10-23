#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gram_low_bg_color=""
gram_medium_bg_color=""
gram_high_bg_color=""

gram_low_default_bg_color="#[bg=green]"
gram_medium_default_bg_color="#[bg=yellow]"
gram_high_default_bg_color="#[bg=red]"

get_bg_color_settings() {
  gram_low_bg_color=$(get_tmux_option "@gram_low_bg_color" "$gram_low_default_bg_color")
  gram_medium_bg_color=$(get_tmux_option "@gram_medium_bg_color" "$gram_medium_default_bg_color")
  gram_high_bg_color=$(get_tmux_option "@gram_high_bg_color" "$gram_high_default_bg_color")
}

print_bg_color() {
  local gram_percentage
  local gram_load_status
  gram_percentage=$("$CURRENT_DIR"/gram_percentage.sh | sed -e 's/%//')
  gram_load_status=$(load_status "$gram_percentage" "gram")
  if [ "$gram_load_status" == "low" ]; then
    echo "$gram_low_bg_color"
  elif [ "$gram_load_status" == "medium" ]; then
    echo "$gram_medium_bg_color"
  elif [ "$gram_load_status" == "high" ]; then
    echo "$gram_high_bg_color"
  fi
}

main() {
  get_bg_color_settings
  print_bg_color
}
main "$@"
