#!/usr/bin/env bash
# https://github.com/xorandd

clear

BRIGHT_RED=$(tput setaf 1)
BRIGHT_GREEN=$(tput setaf 2)
BRIGHT_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# root check
if [[ $EUID -eq 0 ]]; then
    echo "${BRIGHT_RED}[!]${RESET} This script should NOT be executed as root! Exiting..."
    exit 1
fi

INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -n "Are you sure you want to proceed? [Y/n]: "
read choice
choice=${choice:-Y}
if [[ "$choice" =~ ^[Nn]$ ]]; then
    echo "${BRIGHT_YELLOW}[*]${RESET} You chose NOT to proceed with installation."
    exit 1
fi

printf "\nDo you want to install zsh and OhMyZsh? [Y/n]: "
read install_zsh
install_zsh=${install_zsh:-Y}

printf "\nDo you want to install SDDM and theme? [Y/n]: "
read install_sddm
install_sddm=${install_sddm:-Y}

printf "\nDo you want to install grub theme? [Y/n]: "
read install_grub
install_grub=${install_grub:-Y}

if ! command -v git &>/dev/null; then
    sudo pacman -S --noconfirm git > /dev/null 2>&1
fi

./installation_scripts/yay.sh
./installation_scripts/pkg_install.sh
./installation_scripts/sddm.sh "$install_sddm"
./installation_scripts/zsh.sh "$install_zsh"
./installation_scripts/configs.sh
./installation_scripts/grub.sh "$install_grub"
./installation_scripts/theme_icons.sh

mkdir -p "$HOME/Pictures/wallpapers/"
cp "$INSTALLER_DIR/wallpaper/wallpaper1.jpg" "$HOME/Pictures/wallpapers/wallpaper1.jpg"

echo "${BRIGHT_YELLOW}[*]${RESET} Dont forget to reboot system after installer finishes"
sleep 0.5
echo "${BRIGHT_YELLOW}[*]${RESET} After rebooting open nwg-look and select gtk theme 'Flat-Remix-GTKG-Grey-Darkest' with icon theme 'Flat-Remix-Grey-Dark'"
sleep 1
echo "${BRIGHT_GREEN}[+]${RESET} Installation completed!"
