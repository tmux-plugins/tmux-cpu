#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_cpu_percentage() {
	if is_cygwin; then
		usage="$(WMIC cpu get LoadPercentage | grep -Eo '^[0-9]+')"
		printf "%5.1f%%" $usage
	elif [ -e "/proc/stat" ]; then
		grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("%5.1f%", usage)}'
	elif is_osx; then
		iostat -w 1 -c 2 -n 1 | tail -1 | awk '{usage=100-$6} END {printf("%d%%",usage)}';
	elif is_freebsd; then
		iostat -w 1 -c 2 -n 1 | tail -1 | awk '{usage=100-$10} END {printf("%d%%",usage)}';
	fi
}

main() {
	print_cpu_percentage
}
main
