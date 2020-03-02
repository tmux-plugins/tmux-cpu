#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

gram_percentage_format="%3.1f%%"

print_gram_percentage() {
  gram_percentage_format=$(get_tmux_option "@gram_percentage_format" "$gram_percentage_format")

  if command_exists "nvidia-smi"; then
    loads=$(nvidia-smi)
  elif command_exists "cuda-smi"; then
    loads=$(cuda-smi)
  else
    echo "No GPU"
    return
  fi
  loads=$(echo "$loads" | sed -nr 's/.*\s([0-9]+)MiB\s*\/\s*([0-9]+)MiB.*/\1 \2/p')
  echo "$loads" | awk -v format="$gram_percentage_format" '{used+=$1; tot+=$2} END {printf format, 100*$1/$2}'
}

main() {
  print_gram_percentage
}
main
