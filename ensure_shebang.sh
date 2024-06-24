#!/bin/bash
# A test script to verify all .sh files contain a shebang in the current directory and subdirectories

ensure_shebang() {
  local script=$1

  # Read the first line of the script
  local first_line
  first_line=$(head -n 1 "$script")

  # Check if the first line is a shebang
  if [[ "$first_line" != "#!"* ]]; then
    echo "Addding shebang to $script"
    { echo "#!/bin/bash"; cat "$script"; } > "$script.tmp"
    mv "$script.tmp" $script
    return 1
  fi

  return 0
}

main() {
  local error_count=0

  # Find all .sh files in the current directory and subdirectories
  for script in $(fd "\.sh$"); do
    ensure_shebang "$script"
    if [[ $? -ne 0 ]]; then
      ((error_count++))
    fi
  done

  if [[ $error_count -ne 0 ]]; then
    echo "Total files updated: $error_count"
    exit 1
  else
    echo "All scripts already had a shebang."
    exit 0
  fi
}

# Execute the main function
main

