#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_cpu_percentage() {
	if command_exists "iostat"; then

		if is_linux_iostat; then
			iostat -c | tr -s ' ' ';' | grep -e '^;' |  cut -d ';' -f 2 | awk '{print $1"%"}'
		elif is_osx; then
			iostat | tail -1 | tr -s ' ' ';' | sed -e 's/^;//' | cut -d ';' -f 9 | awk '{print $1"%"}'
		elif is_freebsd; then
			iostat | tail -1 | tr -s ' ' ';' | sed -e 's/^;//' | cut -d ';' -f 13 | awk '{print $1"%"}'
		elif [ -e "/proc/stat" ]; then
			grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("%5.1f%", usage)}'
		fi
	else
		if is_cygwin; then
			usage="$(WMIC cpu get LoadPercentage | grep -Eo '^[0-9]+')"
			printf "%5.1f%%" $usage
		elif [ -e "/proc/stat" ]; then
			grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("%5.1f%", usage)}'
		fi
	fi
}

main() {
	print_cpu_percentage
}
main
