#!/usr/bin/env bash
# https://github.com/xorandd

BRIGHT_RED=$(tput setaf 1)
BRIGHT_GREEN=$(tput setaf 2)
BRIGHT_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$1" =~ ^[Nn]$ ]]; then
    echo "${BRIGHT_YELLOW}[*]${RESET} Skipping zsh installation..."
    exit 0
fi

echo -e "\n${BRIGHT_YELLOW}[*]${RESET} Installing Zsh and Oh My Zsh..."
sudo pacman -S --noconfirm zsh zsh-completions fzf lsd >/dev/null 2>&1

# backup existing configs
[ -f "$HOME/.zshrc" ] && cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup"
[ -f "$HOME/.zprofile" ] && cp -b "$HOME/.zprofile" "$HOME/.zprofile-backup"

# install OhMyZsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://install.ohmyz.sh)" "" --unattended > /dev/null 2>&1
fi

# plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1
fi

# copy theme
THEME_DIR="$INSTALLER_DIR/themes/ohmyzsh_theme"
mkdir -p "$HOME/.oh-my-zsh/themes"
if [ -f "$THEME_DIR/darkblood-WHITE.zsh-theme" ]; then
    cp "$THEME_DIR/darkblood-WHITE.zsh-theme" "$HOME/.oh-my-zsh/themes/"
fi

# copy zshrc config
ZSH_CONFIG_DIR="$INSTALLER_DIR/config/zsh-ohmyzsh"
if [ -f "$ZSH_CONFIG_DIR/zshrc" ]; then
    cp -b "$ZSH_CONFIG_DIR/zshrc" "$HOME/.zshrc"
fi

# change shell to zsh
if [ "$(basename $SHELL)" != "zsh" ]; then
    chsh -s $(command -v zsh)
    echo -e "${BRIGHT_GREEN}[+]${RESET} Default shell changed to zsh"
fi

