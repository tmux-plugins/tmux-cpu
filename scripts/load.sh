#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

get_number_of_cores(){
  if is_osx
  then
    sysctl -n hw.ncpu
  else
    nproc
  fi
}


print_load() {
  local num_cores=1
  local output

  case "$(get_tmux_option "@load_per_cpu_core")" in
    true|1|yes)
      num_cores=$(get_number_of_cores)
    ;;
  esac

  output=$(uptime | awk -v num_cores="$num_cores" '{
    sub(/,$/, "", $(NF-2));
    sub(/,$/, "", $(NF-1));
    sub(/,$/, "", $NF);
    sub(/,/, ".", $(NF-2));
    sub(/,/, ".", $(NF-1));
    sub(/,/, ".", $(NF));
    printf "%.2f %.2f %.2f", $(NF-2)/num_cores, $(NF-1)/num_cores, $NF/num_cores
  }')

  case "$1" in
    1)
      output="$(awk '{ print $1 }' <<< "$output")"
      ;;
    5)
      output="$(awk '{ print $2 }' <<< "$output")"
      ;;
    15)
      output="$(awk '{ print $3 }' <<< "$output")"
      ;;
  esac

  echo -n "$output"
}

main() {
  print_load "$@"
}

main "$@"
