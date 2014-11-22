#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

cpu_percentage="#($CURRENT_DIR/scripts/cpu_percentage.sh)"
cpu_icon="#($CURRENT_DIR/scripts/cpu_icon.sh)"
cpu_percentage_interpolation="\#{cpu_percentage}"
cpu_icon_interpolation="\#{cpu_icon}"

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local string=$1
	local percentage_interpolated=${string/$cpu_percentage_interpolation/$cpu_percentage}
	local all_interpolated=${percentage_interpolated/$cpu_icon_interpolation/$cpu_icon}
	echo $all_interpolated
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
