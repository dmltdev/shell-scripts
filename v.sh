#!/bin/bash
# Requires fd, fzf, fzf-tmux, xargs, nvim, tmux
v() {
  selected_file=$(fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p --reverse)
  if [ -n "$selected_file" ]; then
    echo "$selected_file" | xargs nvim
  fi
}
