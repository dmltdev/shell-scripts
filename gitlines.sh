#!/bin/bash
# Script to observe today's repository activity (added and removed lines count) by the current user
gitlines() {
  today=$(date +"%Y-%m-%d")
  
  author=$(git config user.name)

  git log --author="$author" --since="$today 00:00" --until="$today 23:59" --pretty=tformat: --numstat | awk '
  { 
    added += $1; 
    removed += $2 
  } 
  END { 
    printf "Lines Added Today by %s: %s\nLines Removed Today by %s: %s\n", "'$author'", added ? added : 0, "'$author'", removed ? removed : 0 
  }'
}
