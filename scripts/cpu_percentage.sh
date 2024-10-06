#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

cpu_percentage_format="%3.1f%%"

print_cpu_percentage() {
  cpu_percentage_format=$(get_tmux_option "@cpu_percentage_format" "$cpu_percentage_format")

  if command_exists "iostat"; then

    if is_linux_iostat; then
      cached_eval iostat -c 1 2 | sed '/^\s*$/d' | tail -n 1 | awk -v format="$cpu_percentage_format" '{usage=100-$NF} END {printf(format, usage)}' | sed 's/,/./'
    elif is_osx; then
      cached_eval iostat -c 2 disk0 | sed '/^\s*$/d' | tail -n 1 | awk -v format="$cpu_percentage_format" '{usage=100-$6} END {printf(format, usage)}' | sed 's/,/./'
    elif is_freebsd || is_openbsd; then
      cached_eval iostat -c 2 | sed '/^\s*$/d' | tail -n 1 | awk -v format="$cpu_percentage_format" '{usage=100-$NF} END {printf(format, usage)}' | sed 's/,/./'
    else
      echo "Unknown iostat version please create an issue"
    fi
  elif command_exists "sar"; then
    cached_eval sar -u 1 1 | sed '/^\s*$/d' | tail -n 1 | awk -v format="$cpu_percentage_format" '{usage=100-$NF} END {printf(format, usage)}' | sed 's/,/./'
  else
    if is_cygwin; then
      usage="$(cached_eval WMIC cpu get LoadPercentage | grep -Eo '^[0-9]+')"
      # shellcheck disable=SC2059
      printf "$cpu_percentage_format" "$usage"
    else
      load=$(cached_eval ps aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}')
      cpus=$(cpus_number)
      echo "$load $cpus" | awk -v format="$cpu_percentage_format" '{printf format, $1/$2}'
    fi
  fi
}

main() {
  print_cpu_percentage
}
main
