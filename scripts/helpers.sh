#!/usr/bin/env bash

export LANG=C
export LC_ALL=C

get_tmux_option() {
  local option
  local default_value
  local option_value
  option="$1"
  default_value="$2"
  option_value="$(tmux show-option -qv "$option")"
  if [ -z "$option_value" ]; then
    option_value="$(tmux show-option -gqv "$option")"
  fi
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

is_osx() {
  [ "$(uname)" == "Darwin" ]
}

is_freebsd() {
  [ "$(uname)" == "FreeBSD" ]
}

is_openbsd() {
  [ "$(uname)" == "OpenBSD" ]
}

is_linux() {
  [ "$(uname)" == "Linux" ]
}

is_cygwin() {
  command -v WMIC &>/dev/null
}

is_linux_iostat() {
  # Bug in early versions of linux iostat -V return error code
  iostat -c &>/dev/null
}

# is second float bigger or equal?
fcomp() {
  awk -v n1="$1" -v n2="$2" 'BEGIN {if (n1<=n2) exit 0; exit 1}'
}

load_status() {
  local percentage=$1
  local prefix=$2
  medium_thresh=$(get_tmux_option "@${prefix}_medium_thresh" "30")
  high_thresh=$(get_tmux_option "@${prefix}_high_thresh" "80")
  if fcomp "$high_thresh" "$percentage"; then
    echo "high"
  elif fcomp "$medium_thresh" "$percentage" && fcomp "$percentage" "$high_thresh"; then
    echo "medium"
  else
    echo "low"
  fi
}

temp_status() {
  local temp
  temp=$1
  cpu_temp_medium_thresh=$(get_tmux_option "@cpu_temp_medium_thresh" "80")
  cpu_temp_high_thresh=$(get_tmux_option "@cpu_temp_high_thresh" "90")
  if fcomp "$cpu_temp_high_thresh" "$temp"; then
    echo "high"
  elif fcomp "$cpu_temp_medium_thresh" "$temp" && fcomp "$temp" "$cpu_temp_high_thresh"; then
    echo "medium"
  else
    echo "low"
  fi
}

cpus_number() {
  if is_linux; then
    if command_exists "nproc"; then
      nproc
    else
      echo "$(($(sed -n 's/^processor.*:\s*\([0-9]\+\)/\1/p' /proc/cpuinfo | tail -n 1) + 1))"
    fi
  else
    sysctl -n hw.ncpu
  fi
}

command_exists() {
  local command
  command="$1"
  command -v "$command" &>/dev/null
}

get_tmp_dir() {
  local tmpdir
  tmpdir="${TMPDIR:-${TMP:-${TEMP:-/tmp}}}"
  [ -d "$tmpdir" ] || local tmpdir=~/tmp
  echo "$tmpdir/tmux-$EUID-cpu"
}

get_time() {
  date +%s.%N
}

get_cache_val() {
  local key
  local timeout
  local cache
  key="$1"
  # seconds after which cache is invalidated
  timeout="${2:-2}"
  cache="$(get_tmp_dir)/$key"
  if [ -f "$cache" ]; then
    awk -v cache="$(head -n1 "$cache")" -v timeout="$timeout" -v now="$(get_time)" \
      'BEGIN {if (now - timeout < cache) exit 0; exit 1}' &&
      tail -n+2 "$cache"
  fi
}

put_cache_val() {
  local key
  local val
  local tmpdir
  key="$1"
  val="${*:2}"
  tmpdir="$(get_tmp_dir)"
  [ ! -d "$tmpdir" ] && mkdir -p "$tmpdir" && chmod 0700 "$tmpdir"
  (
    get_time
    echo -n "$val"
  ) >"$tmpdir/$key"
  echo -n "$val"
}

cached_eval() {
  local command
  local key
  local val
  command="$1"
  key="$(basename "$command")"
  val="$(get_cache_val "$key")"
  if [ -z "$val" ]; then
    put_cache_val "$key" "$($command "${@:2}")"
  else
    echo -n "$val"
  fi
}
