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

  user=$(git config user.name)

  if [[ "$all" == true ]]; then
    total_added=0
    total_removed=0
    total_files_modified=0
    echo "Stats for user $user from $since to $until across all repositories:"
    echo ""

    for dir in */; do
      if [ -d "$dir/.git" ]; then
        echo "Repository: $dir"
        cd "$dir"

        # Collect stats
        repo_stats=$(git log --all --author="$user" --since="$since" --until="$until" --pretty=tformat: --numstat | awk -v user="$user" -v since="$since" -v until="$until" '
        {
          added += $1;
          removed += $2;
          files++
        }
        END {
          printf "Stats for user %s from %s to %s\n", user, since, until
          printf "Lines Added: %s\nLines Removed: %s\nFiles Modified: %s\n", added ? added : 0, removed ? removed : 0, files ? files : 0
        }')
        echo "$repo_stats"

        added=$(echo "$repo_stats" | grep "Lines Added" | awk '{print $3}')
        removed=$(echo "$repo_stats" | grep "Lines Removed" | awk '{print $3}')
        files_modified=$(echo "$repo_stats" | grep "Files Modified" | awk '{print $4}')

        total_added=$((total_added + added))
        total_removed=$((total_removed + removed))
        total_files_modified=$((total_files_modified + files_modified))

        cd ..
        echo ""
      fi
    done

    echo "Total across all repositories:"
    echo "Lines Added: $total_added"
    echo "Lines Removed: $total_removed"
    echo "Files Modified: $total_files_modified"
  else
    echo "Stats for user $user from $since to $until:"
    echo ""
    git log --all --author="$user" --since="$since" --until="$until" --pretty=tformat: --numstat | awk -v user="$user" -v since="$since" -v until="$until" '
    {
      added += $1;
      removed += $2;
      files++
    }
    END {
      printf "Stats for user %s from %s to %s\n", user, since, until
      printf "Lines of code added: %s\nLines of code removed: %s\nFiles modified: %s\n", added ? added : 0, removed ? removed : 0, files ? files : 0
    }'
  fi
}

