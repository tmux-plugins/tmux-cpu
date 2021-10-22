#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gpu_percentage_format="%3.1f%%"

print_gpu_percentage() {
  gpu_percentage_format=$(get_tmux_option "@gpu_percentage_format" "$gpu_percentage_format")

  if command_exists "nvidia-smi"; then
    loads=$(cached_eval nvidia-smi)
  elif command_exists "cuda-smi"; then
    loads=$(cached_eval cuda-smi)
  else
    echo "No GPU"
    return
  fi
  echo "$loads" | sed -nr 's/.*\s([0-9]+)%.*/\1/p' | awk -v format="$gpu_percentage_format" '{sum+=$1; n+=1} END {printf format, sum/n}'
}

main() {
  print_gpu_percentage
}
main
