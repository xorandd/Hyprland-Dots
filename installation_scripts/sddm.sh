#!/usr/bin/env bash
# https://github.com/xorandd

BRIGHT_RED=$(tput setaf 1)
BRIGHT_GREEN=$(tput setaf 2)
BRIGHT_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_INSTALLER="$SCRIPT_DIR/../themes/sddm_theme/silent/install.sh"

if [[ "$1" =~ ^[Nn]$ ]]; then
    echo "${BRIGHT_YELLOW}[*]${RESET} Skipping SDDM installation..."
    exit 0
fi

# install SDDM if not installed
if ! pacman -Q sddm &>/dev/null; then
    echo "${BRIGHT_YELLOW}[*]${RESET} Installing SDDM..."
    sudo pacman -S --noconfirm sddm
else
    echo "${BRIGHT_GREEN}[+]${RESET} SDDM is already installed."
fi

# run theme installer
if [[ -f "$THEME_INSTALLER" ]]; then
    echo "${BRIGHT_YELLOW}[*]${RESET} Running Silent SDDM theme installer..."
    sudo bash "$THEME_INSTALLER"
else
    echo "${BRIGHT_RED}[!]${RESET} Silent theme installer not found at $THEME_INSTALLER"
fi

# Enable SDDM service
echo "${BRIGHT_YELLOW}[*]${RESET} Enabling and starting SDDM..."
sudo systemctl enable sddm.service

