#!/bin/bash
# Script to observe today's repository activity (added and removed lines count)
gitlines() {
  today=$(date +"%Y-%m-%d")

  git log --since="$today 00:00" --until="$today 23:59" --pretty=tformat: --numstat | awk '
  { 
    added += $1; 
    removed += $2 
  } 
  END { 
    printf "Lines Added Today: %s\nLines Removed Today: %s\n", added ? added : 0, removed ? removed : 0 
  }'
}

