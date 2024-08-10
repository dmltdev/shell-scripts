#!/bin/bash
# Script to observe repository activity (added and removed lines count) by the current user
gitlines() {
  # Default to today's date if --since and --until are not provided
  today=$(date +"%Y-%m-%d")
  since="$today 00:00" # Example: gitlines --since '2024-07-01 00:00'
  until="$today 23:59" # Example: gitlines --since '2024-07-01 00:00' --until "2024-09-01 23:59"

  while [[ "$1" =~ ^-- ]]; do
    case $1 in
      --since)
        since="$2"
        shift 2
        ;;
      --until)
        until="$2"
        shift 2
        ;;
      --all)
        all=true
        shift
        ;;
      *)
        echo "Unknown flag: $1"
        return 1
        ;;
    esac
  done

  if [[ "$all" == true ]]; then
    total_added=0
    total_removed=0
    for dir in */; do
      if [ -d "$dir/.git" ]; then
        echo "Repository: $dir"
        cd "$dir"
        repo_stats=$(git log --all --author="$(git config user.name)" --since="$since" --until="$until" --pretty=tformat: --numstat | awk '
        { 
          added += $1; 
          removed += $2 
        } 
        END { 
          printf "Lines Added: %s\nLines Removed: %s\n", added ? added : 0, removed ? removed : 0 
        }')
        echo "$repo_stats"
        
        added=$(echo "$repo_stats" | grep "Lines Added" | awk '{print $3}')
        removed=$(echo "$repo_stats" | grep "Lines Removed" | awk '{print $3}')
        total_added=$((total_added + added))
        total_removed=$((total_removed + removed))
        cd ..
        echo ""
      fi
    done

    echo "Total across all repositories:"
    echo "Lines Added: $total_added"
    echo "Lines Removed: $total_removed"
  else
    git log --all --author="$(git config user.name)" --since="$since" --until="$until" --pretty=tformat: --numstat | awk '
    { 
      added += $1; 
      removed += $2 
    } 
    END { 
      printf "Lines Added: %s\nLines Removed: %s\n", added ? added : 0, removed ? removed : 0 
    }'
  fi
}
