#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_cpu_percentage() {
	if [ -e "/proc/stat" ]; then
		grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("%.1f%", usage)}'
	elif [ is_osx ]; then
		iostat -w 1 -c 2 -n 1 | tail -1 | awk '{usage=100-$6} END {printf("%d%%",usage)}';
	fi
}

main() {
	print_cpu_percentage
}
main
