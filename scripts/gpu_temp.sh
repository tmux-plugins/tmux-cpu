#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

gpu_temp_format="%2.0f"

print_gpu_temp() {
  gpu_temp_format=$(get_tmux_option "@gpu_temp_format" "$gpu_temp_format")

  if command_exists "nvidia-smi"; then
    loads=$(cached_eval nvidia-smi)
  elif command_exists "cuda-smi"; then
    loads=$(cached_eval cuda-smi)
  else
    echo "No GPU"
    return
  fi
  echo "$loads" | sed -nr 's/.*\s([0-9]+)C.*/\1/p' | awk -v format="${gpu_temp_format}C" '{sum+=$1; n+=1} END {printf format, sum/n}'
}

main() {
  print_gpu_temp
}
main
