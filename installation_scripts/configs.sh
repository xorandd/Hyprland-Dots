#!/usr/bin/env bash
# https://github.com/xorandd

CONFIG_DIR="$HOME/.config"
ICONS_DIR="$HOME/.icons"
ZSH_DIR="$HOME/.oh-my-zsh/themes"
INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$CONFIG_DIR" "$ICONS_DIR" "$ZSH_DIR"

echo "Copying configuration files..."
cp -r "$INSTALLER_DIR/config/hypr" "$CONFIG_DIR/"
cp -r "$INSTALLER_DIR/config/waybar" "$CONFIG_DIR/"
cp -r "$INSTALLER_DIR/config/wlogout" "$CONFIG_DIR/"
cp -r "$INSTALLER_DIR/config/rofi" "$CONFIG_DIR/"
cp -r "$INSTALLER_DIR/config/kitty" "$CONFIG_DIR/"
cp -r "$INSTALLER_DIR/config/fastfetch" "$CONFIG_DIR/"

