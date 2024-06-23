# Source all .sh files except those that are listed in the first scenario
for file in ~/shell-scripts/*.sh; do
  case "$file" in
    *setup.sh|*install.sh)
      # Skip these files
      continue
      ;;
    *)
      source "$file"
      ;;
  esac
done

