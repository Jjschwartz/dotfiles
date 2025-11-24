# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Disable annoying apple using .zshrc warning
export BASH_SILENCE_DEPRECATION_WARNING=1
