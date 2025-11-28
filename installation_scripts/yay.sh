#!/usr/bin/env bash
# https://github.com/xorandd

BRIGHT_RED=$(tput setaf 1)
BRIGHT_GREEN=$(tput setaf 2)
BRIGHT_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

pkg="yay-bin"

if command -v yay &>/dev/null; then
    echo -e "\n${BRIGHT_GREEN}[+]${RESET} Yay already installed, moving on.\n"
else
    echo -e "\nInstalling $pkg from AUR\n"
    if [[ -d "$pkg" ]]; then
        rm -rf "$pkg"
    fi
    git clone https://aur.archlinux.org/$pkg.git > /dev/null 2>&1 || { echo -e "${BRIGHT_RED}[!]${RESET} Failed to clone $pkg"; exit 1; }
    cd $pkg || exit 1
    makepkg -si --noconfirm > /dev/null || { echo -e "${BRIGHT_RED}[!]${RESET} Failed to build $pkg"; exit 1; }
    echo -e "${BRIGHT_GREEN}[+]${RESET} Yay has been installed successfully!"
    cd -
fi

