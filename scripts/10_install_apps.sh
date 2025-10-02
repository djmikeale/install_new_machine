#!/bin/bash
set -euo pipefail

append_if_missing() {
    local file=$1
    local line=$2
    grep -qxF "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "→ Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✓ Homebrew already installed"
fi

# Make sure brew is in PATH
append_if_missing ~/.zprofile 'eval "$(/opt/homebrew/bin/brew shellenv)"'
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update Homebrew
echo "→ Updating Homebrew"
brew update
brew upgrade
brew cleanup

eval "$(/opt/homebrew/bin/brew shellenv)"

# Formulae
homebrew_apps=(
    bat
    ffmpeg
    fzf
    gh
    git
    jq
    pyenv
    tree
    zsh-autosuggestions
    zsh-syntax-highlighting
)

for app in "${homebrew_apps[@]}"; do
    if brew list "$app" &>/dev/null; then
        echo "✓ $app already installed"
    else
        echo "→ Installing $app"
        brew install "$app"
    fi
done

# Oh My Zsh
echo "=== Installing oh-my-zsh ==="
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✓ oh-my-zsh already installed"
fi

# give man and --help pages pretty colours
append_if_missing ~/.zshrc 'export MANPAGER="sh -c '\''col -bx | bat -l man -p'\''"'
append_if_missing ~/.zshrc "alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'"
append_if_missing ~/.zshrc "alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'"

# Powerlevel10k
echo "=== Installing Powerlevel10k theme ==="
if [ ! -d "$HOME/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    append_if_missing ~/.zshrc 'source ~/powerlevel10k/powerlevel10k.zsh-theme'
else
    echo "✓ Powerlevel10k already installed"
fi

# Pyenv setup
echo "=== Setting up pyenv ==="
global_python_version="3.12.6"
pyenv install "$global_python_version"
pyenv global "$global_python_version"


# Zsh Plugins
echo "=== Configuring Zsh plugins ==="
append_if_missing ~/.zshrc "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
append_if_missing ~/.zshrc "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
append_if_missing ~/.zshrc "source <(fzf --zsh)"

# Cask Apps
homebrew_cask_apps=(
    alt-tab
    bettertouchtool
    firefox
    google-chrome
    iterm2
    obsidian
    qobuz
    raycast
    slack
    time-out
    transmission
    visual-studio-code
)

for app in "${homebrew_cask_apps[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
        echo "✓ $app already installed"
    else
        echo "→ Installing $app"
        brew install --cask "$app"
    fi
done


# Firefox
if command -v firefox &>/dev/null; then
    open -a "Firefox" --args --make-default-browser
fi

# Install/upgrade uv (Astral)
curl -LsSf https://astral.sh/uv/install.sh | sh
