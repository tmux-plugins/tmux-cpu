#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_gpu_percentage() {
	if command_exists "nvidia-smi"; then
		loads=$(nvidia-smi)
	elif command_exists "cuda-smi"; then
		loads=$(cuda-smi)
	else
		echo "nvidia-smi/cuda-smi not found"
		return
	fi
	loads=$(echo "$loads" | sed -nr 's/.*\s([0-9]+)%.*/\1/p')
	gpus=$(echo "$loads" | wc -l)
	load=$(echo "$loads" | awk '{count+=$1} END {print count}')
	echo "$load $gpus" | awk '{printf "%3.0f%%", $1/$2}'
}

main() {
	print_gpu_percentage
}
main
