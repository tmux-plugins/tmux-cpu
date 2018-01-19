#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_cpu_percentage() {
	if command_exists "iostat"; then

		if is_linux_iostat; then
			iostat -c 1 2 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$NF} END {printf("%5.1f%%", usage)}' | sed 's/,/./'
		elif is_osx; then
			iostat -c 2 disk0 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$6} END {printf("%5.1f%%", usage)}' | sed 's/,/./'
		elif is_freebsd || is_openbsd; then
			iostat -c 2 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$NF} END {printf("%5.1f%%", usage)}' | sed 's/,/./'
		else
			echo "Unknown iostat version please create an issue"
		fi
	elif command_exists "sar"; then
		sar -u 1 1 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$NF} END {printf("%5.1f%%", usage)}' | sed 's/,/./'
	else
		if is_cygwin; then
			usage="$(WMIC cpu get LoadPercentage | grep -Eo '^[0-9]+')"
			printf "%5.1f%%" $usage
		else
			load=`ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'`
			cpus=$(cpus_number)
			echo "$load $cpus" | awk '{printf "%5.2f%%", $1/$2}'
		fi
	fi
}

main() {
	print_cpu_percentage
}
main
