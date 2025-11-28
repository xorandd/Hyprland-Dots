#!/usr/bin/env bash
# https://github.com/xorandd

BRIGHT_RED=$(tput setaf 1)
BRIGHT_GREEN=$(tput setaf 2)
BRIGHT_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

REQUIRED_PACKAGES=(
    curl
    firefox
    htop
    btop
    thunar
    nwg-look
    rofi
    kitty
    waybar
    wlogout
    hypridle
    fastfetch
    cliphist
    bluez
    blueman
    nvim
    pamixer
    swww
    pavucontrol
    playerctl
    qt5ct
    qt6ct
    qt6-svg
    wl-clipboard
    grim
    slurp
    adwaita-fonts
    noto-fonts-emoji
    ttf-fantasque-sans-mono
    ttf-fantasque-nerd
    ttf-montserrat
    ttf-jetbrains-mono-nerd
)

is_package_installed(){
    pacman -Q "$1" &>/dev/null
}

echo -e "\n${BRIGHT_YELLOW}[*]${RESET} Checking and installing missing packages..."
for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! is_package_installed "$package"; then
        echo "${BRIGHT_RED}[x]${RESET} Package '$package' not found. Installing..."
	if [[ "$package" == "wlogout" ]]; then
	    yay -S --noconfirm "$package" > /dev/null 2>&1
	else
            sudo pacman -S --noconfirm "$package" > /dev/null 2>&1
	fi
    else
        echo "${BRIGHT_GREEN}[+]${RESET} Package '$package' is already installed."
    fi
done

