#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

cpu_interpolation=(
	"\#{cpu_percentage}"
	"\#{cpu_icon}"
	"\#{cpu_bg_color}"
	"\#{cpu_fg_color}"
	"\#{gpu_percentage}"
	"\#{gpu_icon}"
	"\#{gpu_bg_color}"
	"\#{gpu_fg_color}"
)
cpu_commands=(
	"#($CURRENT_DIR/scripts/cpu_percentage.sh)"
	"#($CURRENT_DIR/scripts/cpu_icon.sh)"
	"#($CURRENT_DIR/scripts/cpu_bg_color.sh)"
	"#($CURRENT_DIR/scripts/cpu_fg_color.sh)"
	"#($CURRENT_DIR/scripts/gpu_percentage.sh)"
	"#($CURRENT_DIR/scripts/gpu_icon.sh)"
	"#($CURRENT_DIR/scripts/gpu_bg_color.sh)"
	"#($CURRENT_DIR/scripts/gpu_fg_color.sh)"
)

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local all_interpolated="$1"
	for ((i=0; i<${#cpu_commands[@]}; i++)); do
		all_interpolated=${all_interpolated/${cpu_interpolation[$i]}/${cpu_commands[$i]}}
	done
	echo "$all_interpolated"
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
