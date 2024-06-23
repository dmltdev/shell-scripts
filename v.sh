# Requires fd, fzf, fzf-tmux, xargs, nvim, tmux
alias v = "fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p --reverse | xargs nvim"
