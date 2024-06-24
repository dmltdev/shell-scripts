#!/bin/bash
# Tests the shell command and returns the report back
# Dependencies: shellcheck, strace

sht() {
  local script=$1

  if [[ ! -f "$script" ]]; then
      echo "Error: script '$script' not found."
      return 1
  fi

  echo "Running shellcheck on $script"
  shellcheck $script

  echo "Running strace on $script"
  strace -o "sht_logs/{script}_trace.txt" -f bash "$script"

  echo "Saved strace output to sht_logs/${script}_trace.txt"
}
