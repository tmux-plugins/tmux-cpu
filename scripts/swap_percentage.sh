#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

swap_percentage_format="%3.1f%%"

print_swap_percentage() {
  swap_percentage_format=$(get_tmux_option "@swap_percentage_format" "$swap_percentage_format")

  if command_exists "iostat"; then

    if is_linux_iostat; then
      free -t | awk 'NR == 3 {printf("Current Swap Utilization is : %.2f%"), $3/$2*100}'
    elif is_osx; then
      free -t | awk 'NR == 3 {printf("Current Swap Utilization is : %.2f%"), $3/$2*100}'
    elif is_freebsd || is_openbsd; then
      free -t | awk 'NR == 3 {printf("Current Swap Utilization is : %.2f%"), $3/$2*100}'
    else
      echo "Unknown iostat version please create an issue"
    fi
  elif command_exists "sar"; then
    free -t | awk 'NR == 3 {printf("Current Swap Utilization is : %.2f%"), $3/$2*100}'
  else
    if is_cygwin; then
      usage="$(cached_eval WMIC swap get LoadPercentage | grep -Eo '^[0-9]+')"
      printf "$swap_percentage_format" "$usage"
    else
      load=`cached_eval ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'`
      swaps=$(swaps_number)
      echo "$load $swaps" | awk -v format="$swap_percentage_format" '{printf format, $1/$2}'
    fi
  fi
}

main() {
  print_swap_percentage
}
main
