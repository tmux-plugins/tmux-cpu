#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

# script global variables
gram_low_icon=""
gram_medium_icon=""
gram_high_icon=""

gram_low_default_icon="="
gram_medium_default_icon="≡"
gram_high_default_icon="≣"

# icons are set as script global variables
get_icon_settings() {
  gram_low_icon=$(get_tmux_option "@gram_low_icon" "$gram_low_default_icon")
  gram_medium_icon=$(get_tmux_option "@gram_medium_icon" "$gram_medium_default_icon")
  gram_high_icon=$(get_tmux_option "@gram_high_icon" "$gram_high_default_icon")
}

print_icon() {
  local gram_percentage
  local gram_load_status
  gram_percentage=$("$CURRENT_DIR"/gram_percentage.sh | sed -e 's/%//')
  gram_load_status=$(load_status "$gram_percentage" "gram")
  if [ "$gram_load_status" == "low" ]; then
    echo "$gram_low_icon"
  elif [ "$gram_load_status" == "medium" ]; then
    echo "$gram_medium_icon"
  elif [ "$gram_load_status" == "high" ]; then
    echo "$gram_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main "$@"
