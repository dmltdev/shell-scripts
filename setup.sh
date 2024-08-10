#!/bin/bash
# Source all .sh files except those that are listed in the first scenario
for file in ~/shell-scripts/*.sh; do
  case "$file" in
    *sht.sh|*ns.sh|*lt.sh|*v.sh|*gitlines.sh)
      source "$file"
      ;;
    *)
      # Skip all other scripts
      ;;
  esac
done
