#!/usr/bin/env bash
#
# Personal Dotfiles & Environment Setup Script
# =============================================
#
# Installs dotfiles and dev tools on macOS or Linux (Debian/Ubuntu).
#
# INSTALLS:
#   Homebrew (macOS), bash, bash-completion, starship, bat, fzf, direnv,
#   git-delta, tmux, neovim, lazygit, mactop (macOS), Claude Code, dotfiles
#
# ============================================================================
# SETUP INSTRUCTIONS
# ============================================================================
#
# --- macOS (editable, with SSH) ---
#
#   # 1. Set up SSH key (copy existing or generate new)
#   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_jjschwartz
#
#   # 2. Add key to GitHub: https://github.com/settings/keys
#   cat ~/.ssh/id_ed25519_jjschwartz.pub
#
#   # 3. Configure SSH host alias
#   mkdir -p ~/.ssh && cat >> ~/.ssh/config << 'EOF'
#   Host github.com-jjschwartz
#     HostName github.com
#     AddKeysToAgent yes
#     IdentityFile ~/.ssh/id_ed25519_jjschwartz
#   EOF
#
#   # 4. Run install script
#   curl -fsSL https://raw.githubusercontent.com/jjschwartz/dotfiles/main/install-dotfiles.sh | bash
#
# --- Linux (editable, with SSH) ---
#
#   # 1. Set up SSH key and add to GitHub (as above)
#
#   # 2. Run install script (requires root or sudo)
#   curl -fsSL https://raw.githubusercontent.com/jjschwartz/dotfiles/main/install-dotfiles.sh | bash
#
# --- Ephemeral server (read-only, no SSH required) ---
#
#   curl -fsSL https://raw.githubusercontent.com/jjschwartz/dotfiles/main/install-dotfiles.sh | DOTFILES_MODE=https bash
#
# ============================================================================
#
# ENVIRONMENT VARIABLES:
#   DOTFILES_MODE  - "ssh" (default, editable) or "https" (read-only)
#
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    printf "${GREEN}[INFO]${NC} %s\n" "$1"
}

log_warn() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
}

log_section() {
    echo ""
    printf "${BLUE}===${NC} %s ${BLUE}===${NC}\n" "$1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

# Run command with sudo if needed (handles running as root or without sudo)
run_privileged() {
    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif command_exists sudo; then
        sudo "$@"
    else
        log_error "Need root privileges but sudo is not available"
        exit 1
    fi
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin)
            OS="macos"
            ;;
        Linux)
            OS="linux"
            ;;
        *)
            log_error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
    log_info "Detected OS: $OS"
}

# macOS: Install Homebrew if not present
install_homebrew() {
    if [[ "$OS" != "macos" ]]; then
        return 0
    fi

    log_section "Homebrew"

    if command_exists brew; then
        log_info "Homebrew is already installed: $(brew --version | head -n1)"
        return 0
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    log_info "Homebrew installed successfully"
}

# Install a package using the appropriate package manager
install_package() {
    local package="$1"
    local brew_name="${2:-$1}"  # Optional different name for brew

    if [[ "$OS" == "macos" ]]; then
        if brew list "$brew_name" &> /dev/null; then
            log_info "$brew_name is already installed"
        else
            log_info "Installing $brew_name..."
            brew install "$brew_name"
        fi
    else
        if dpkg -l "$package" &> /dev/null 2>&1; then
            log_info "$package is already installed"
        else
            log_info "Installing $package..."
            run_privileged apt-get install -y "$package"
        fi
    fi
}

# Install CLI tools
install_cli_tools() {
    log_section "CLI Tools"

    if [[ "$OS" == "linux" ]]; then
        log_info "Updating apt package list..."
        run_privileged apt-get update
    fi

    # bash (macOS only - Linux already has bash)
    if [[ "$OS" == "macos" ]]; then
        install_package "bash" "bash"
    fi

    # bash-completion
    if [[ "$OS" == "macos" ]]; then
        install_package "bash-completion" "bash-completion@2"
    else
        install_package "bash-completion"
    fi

    # starship prompt
    if command_exists starship; then
        log_info "starship is already installed"
    else
        log_info "Installing starship..."
        if [[ "$OS" == "macos" ]]; then
            brew install starship
        else
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        fi
    fi

    # bat (better cat)
    if [[ "$OS" == "macos" ]]; then
        install_package "bat"
    else
        install_package "bat"
        # On Debian/Ubuntu, bat is installed as 'batcat'
        if command_exists batcat && ! command_exists bat; then
            log_info "Creating bat symlink for batcat..."
            run_privileged ln -sf "$(which batcat)" /usr/local/bin/bat 2>/dev/null || true
        fi
    fi

    # fzf (fuzzy finder)
    install_package "fzf"

    # direnv
    install_package "direnv"

    # git-delta (better diffs)
    if [[ "$OS" == "macos" ]]; then
        install_package "delta" "git-delta"
    else
        if command_exists delta; then
            log_info "delta is already installed"
        else
            log_info "Installing delta..."
            # Download latest release for Linux
            local delta_version
            delta_version=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
            curl -fsSL "https://github.com/dandavison/delta/releases/download/${delta_version}/git-delta_${delta_version}_amd64.deb" -o /tmp/delta.deb
            run_privileged dpkg -i /tmp/delta.deb
            rm /tmp/delta.deb
        fi
    fi

    # tmux
    install_package "tmux"

    # neovim
    if [[ "$OS" == "macos" ]]; then
        install_package "neovim"
    else
        if command_exists nvim; then
            log_info "neovim is already installed"
        else
            log_info "Installing neovim..."
            local arch
            arch=$(uname -m)
            if [[ "$arch" == "aarch64" ]]; then
                arch="arm64"
            fi
            curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.appimage" -o /tmp/nvim.appimage
            chmod u+x /tmp/nvim.appimage
            run_privileged mv /tmp/nvim.appimage /usr/local/bin/nvim
        fi
    fi

    # lazygit
    if [[ "$OS" == "macos" ]]; then
        install_package "lazygit"
    else
        if command_exists lazygit; then
            log_info "lazygit is already installed"
        else
            log_info "Installing lazygit..."
            local lazygit_version
            lazygit_version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
            curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz
            tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
            run_privileged mv /tmp/lazygit /usr/local/bin/
            rm /tmp/lazygit.tar.gz
        fi
    fi

    # mactop (macOS only - Apple Silicon monitor)
    if [[ "$OS" == "macos" ]]; then
        install_package "mactop"
    fi
}

# Install Claude Code
install_claude_code() {
    log_section "Claude Code"

    if command_exists claude; then
        log_info "Claude Code is already installed: $(claude --version 2>/dev/null || echo 'installed')"
        return 0
    fi

    log_info "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash

    # Ensure ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    log_info "Claude Code installed successfully"
}

# Setup dotfiles using bare git repo
setup_dotfiles() {
    log_section "Dotfiles"

    local dotfiles_dir="$HOME/.dotfiles"
    local dotfiles_alias='alias dotf="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"'

    # Define the alias for this session
    alias dotf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    if [[ -d "$dotfiles_dir" ]]; then
        log_info "Dotfiles directory already exists at $dotfiles_dir"
        log_info "Pulling latest changes..."
        /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" pull || log_warn "Failed to pull, may need manual intervention"
        return 0
    fi

    # Determine clone URL based on DOTFILES_MODE
    local clone_url
    local mode="${DOTFILES_MODE:-ssh}"

    if [[ "$mode" == "https" ]]; then
        clone_url="https://github.com/jjschwartz/dotfiles.git"
        log_info "Cloning dotfiles via HTTPS (read-only)..."
    else
        # SSH mode - determine host based on OS
        local git_host
        if [[ "$OS" == "macos" ]]; then
            git_host="github.com-jjschwartz"
        else
            git_host="github.com"
        fi
        clone_url="git@${git_host}:jjschwartz/dotfiles.git"
        log_info "Cloning dotfiles via SSH (editable)..."
    fi

    git clone --bare "$clone_url" "$dotfiles_dir"

    # Checkout dotfiles, backing up any conflicts
    log_info "Checking out dotfiles..."
    if /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" checkout 2>/dev/null; then
        log_info "Dotfiles checked out successfully"
    else
        log_warn "Backing up pre-existing dotfiles to ~/.dotfiles-backup..."
        mkdir -p "$HOME/.dotfiles-backup"
        /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" checkout 2>&1 \
            | grep -E "^\s+" \
            | awk '{print $1}' \
            | xargs -I{} mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"
        /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" checkout
        log_info "Dotfiles checked out successfully (conflicts backed up)"
    fi

    # Hide untracked files
    /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" config --local status.showUntrackedFiles no

    log_info "Dotfiles setup complete ($mode mode)"
    if [[ "$mode" == "https" ]]; then
        log_warn "Read-only mode: use 'dotf pull' to update, but cannot push changes"
    fi
    log_info "Add the following alias to your shell config:"
    log_info "  $dotfiles_alias"
}

# Main
main() {
    echo ""
    log_info "=========================================="
    log_info "  Personal Dotfiles & Environment Setup"
    log_info "=========================================="
    echo ""

    detect_os

    install_homebrew
    install_cli_tools
    install_claude_code
    setup_dotfiles

    log_section "Setup Complete!"
    echo ""
    log_info "Installed tools:"
    log_info "  - bash, bash-completion"
    log_info "  - starship (prompt)"
    log_info "  - bat (better cat)"
    log_info "  - fzf (fuzzy finder)"
    log_info "  - direnv"
    log_info "  - delta (better diffs)"
    log_info "  - tmux"
    log_info "  - neovim"
    log_info "  - lazygit"
    [[ "$OS" == "macos" ]] && log_info "  - mactop (Apple Silicon monitor)"
    log_info "  - Claude Code"
    log_info "  - Dotfiles (bare repo)"
    echo ""
    log_info "You may need to restart your shell or run:"
    log_info "  source ~/.bashrc"
    echo ""
}

main "$@"
