# Bash command aliases
# Force color output and group directories first
alias ls='ls --color=auto --group-directories-first'
# List in long format with readable file sizes (KB, MB, GB)
alias ll='ls -lh'
# List all files, including hidden ones (dotfiles)
alias la='ls -A'
# The "everything" command: long format, human-readable, showing hidden files
alias lla='ls -larth'

# Git commands
# General utility aliases
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gcm="git commit -m"
alias gsw="git switch"
alias gstashpull="git add .; git stash; git pull; git stash pop"

# More useful timeout
alias timeout="gtimeout"

# Alias for dotfiles bare repo
alias dotf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree $HOME'

# ---- NVIM ----
alias vi='nvim'  # Use 'nvim' (Neovim) when typing 'vi'
alias vim='nvim'  # Use 'nvim' when typing 'vim'
# ---- END NVIM ----
