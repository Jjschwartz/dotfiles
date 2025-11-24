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

# Homebrew - setup PATH and other env vars
# Includes adding updated bash version
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup direnv hook
# See: https://direnv.net/docs/hook.html
eval "$(direnv hook bash)"

# Colorize prompt (simple version)
# For basic colored prompt:
export PS1="\[\033[36m\]\u \W \\$ \[\033[0m\]"

# ---- NVM -----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# ---- END NVM ----

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
# ---- END FZF -----

# Created by `pipx` on 2024-10-28 15:33:58
export PATH="$PATH:/Users/jonathon/.local/bin"

# ---- Starship ----
eval "$(starship init bash)"

# ---- UV ----
# Bash completion for uv
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"

# Helper functions
function uvrun() {
    uv run "$@"
}

function uvrunx() {
    uvx "$@"
}

# Enable bash completion
# MacOS: `brew install bash-completion@2
# linux: `sudo apt install bash-completion`
# Conditionals are to handle cross-platform (linux vs macos)
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f $(brew --prefix 2>/dev/null)/share/bash-completion/bash_completion ]; then
    . $(brew --prefix)/share/bash-completion/bash_completion
fi

# bash completion support for Pants (if available)
if [ -f ~/.bash/pants-completions.bash ]; then
    source ~/.bash/pants-completions.bash
fi
