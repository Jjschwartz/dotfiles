# This is a mix of my own local .bashrc and the one generated via the ansible script

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Homebrew - setup PATH and other env vars
# Includes adding updated bash version
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Setup direnv hook
# See: https://direnv.net/docs/hook.html
eval "$(direnv hook bash)"

# ---- GCLOUD ---
# Google cloud sdk (if available)
if [ -f $HOME/google-cloud-sdk/bin ]; then
    export PATH=$PATH:$HOME/google-cloud-sdk/bin
fi

# gcloud completions
# linux: look in snap dirs
if [ -f /snap/google-cloud-cli/current/completion.bash.inc ]; then
    source /snap/google-cloud-cli/current/completion.bash.inc
fi

if [ -f /snap/google-cloud-sdk/current/path.bash.inc ]; then
    source /snap/google-cloud-sdk/current/path.bash.inc
fi
# ---- GCLOUD ---

# Colorize prompt (simple version)
# For basic colored prompt:
export PS1="\[\033[36m\]\u \W \\$ \[\033[0m\]"

# ---- NVM -----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

load-nvmrc() {
  local nvmrc_path nvmrc_node_version
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

load-nvmrc
# ---- END NVM ----

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(fzf --bash)"
# ---- END FZF -----

# ---- Starship ----
# Installation:
# Linux: `curl -sS https://starship.rs/install.sh | sh`
# MacOS: `brew install starship`
eval "$(starship init bash)"
# ---- END Starship ----

# ---- BASH COMPLETION ----
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
# ---- END BASH COMPLETION ----

# ---- PANTS ----
# bash completion support for Pants (if available)
if [ -f ~/.bash/pants-completions.bash ]; then
    source ~/.bash/pants-completions.bash
fi
export PANTS_PROCESS_LOCAL_EXECUTION_ROOT_DIR=$HOME/.cache/pants/tmp
# ---- END PANTS ----

# ---- PATH ----
export PATH="$HOME/.local/bin:$PATH"
. "$HOME/.local/bin/env"
# ---- END PATH ----

# ---- UV ----
# NOTE: needs to be placed after PATH update so uv can be found
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
# ---- END UV ----
