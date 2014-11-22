#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
cpu_icon=""

cpu_default="❏ "

# icons are set as script global variables
get_icon_settings() {
	cpu_icon=$(get_tmux_option "@cpu_icon" "$cpu_default")
}

main() {
	get_icon_settings
	printf "$cpu_icon"
}
main
