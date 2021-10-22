#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

gpu_temp_format="%2.0f"
gpu_temp_unit="C"

print_gpu_temp() {
  gpu_temp_format=$(get_tmux_option "@gpu_temp_format" "$gpu_temp_format")
  gpu_temp_unit=$(get_tmux_option "@gpu_temp_unit" "$gpu_temp_unit")

  if command_exists "nvidia-smi"; then
    loads=$(cached_eval nvidia-smi)
  elif command_exists "cuda-smi"; then
    loads=$(cached_eval cuda-smi)
  else
    echo "No GPU"
    return
  fi
  tempC=$(echo "$loads" | sed -nr 's/.*\s([0-9]+)C.*/\1/p' | awk '{sum+=$1; n+=1} END {printf "%5.3f", sum/n}')
  if [ "$gpu_temp_unit" == "C" ]; then
    echo "$tempC" | awk -v format="${gpu_temp_format}C" '{sum+=$1} END {printf format, sum}'
  else
    echo "$tempC" | awk -v format="${gpu_temp_format}F" '{sum+=$1} END {printf format, sum*9/5+32}'
  fi
}

main() {
  print_gpu_temp
}
main "$@"
