
# General utility aliases
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gcm="git commit -m"
alias gsw="git switch"
alias gstashpull="git add .; git stash; git pull; git stash pop"

alias timeout="gtimeout"

# Alias for dotfiles bare repo
alias dotf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree $HOME'

# ---- NVIM ----
alias vi='nvim'  # Use 'nvim' (Neovim) when typing 'vi'
alias vim='nvim'  # Use 'nvim' when typing 'vim'
# ---- END NVIM ----
