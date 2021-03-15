#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

swap_percentage_format="%3.1f%%"

print_swap_percentage() {
  swap_percentage_format=$(get_tmux_option "@swap_percentage_format" "$swap_percentage_format")

  if command_exists "free"; then
    free -t | awk 'NR == 3 {printf("Current Swap Utilization is : %.2f%"), $3/$2*100}'
  elif command_exists "cuda-smi"; then
    loads=$(cached_eval cuda-smi | sed -nr 's/.*\s([0-9.]+) of ([0-9.]+) MB.*/\1 \2/p' | awk '{print $2-$1" "$2}')
  else
    echo "No SWAP"
    return
  fi
  echo "$loads" | awk -v format="$swap_percentage_format" '{used+=$1; tot+=$2} END {printf format, 100*$1/$2}'
}

main() {
  print_swap_percentage
}
main
