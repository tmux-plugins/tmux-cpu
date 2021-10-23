#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gram_low_fg_color=""
gram_medium_fg_color=""
gram_high_fg_color=""

gram_low_default_fg_color="#[fg=green]"
gram_medium_default_fg_color="#[fg=yellow]"
gram_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  gram_low_fg_color=$(get_tmux_option "@gram_low_fg_color" "$gram_low_default_fg_color")
  gram_medium_fg_color=$(get_tmux_option "@gram_medium_fg_color" "$gram_medium_default_fg_color")
  gram_high_fg_color=$(get_tmux_option "@gram_high_fg_color" "$gram_high_default_fg_color")
}

print_fg_color() {
  local gram_percentage
  local gram_load_status
  gram_percentage=$("$CURRENT_DIR"/gram_percentage.sh | sed -e 's/%//')
  gram_load_status=$(load_status "$gram_percentage" "gram")
  if [ "$gram_load_status" == "low" ]; then
    echo "$gram_low_fg_color"
  elif [ "$gram_load_status" == "medium" ]; then
    echo "$gram_medium_fg_color"
  elif [ "$gram_load_status" == "high" ]; then
    echo "$gram_high_fg_color"
  fi
}

main() {
  get_fg_color_settings
  print_fg_color
}
main "$@"
