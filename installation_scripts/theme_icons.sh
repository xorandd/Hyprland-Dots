#!/usr/bin/env bash

GTK_THEME_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"
INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$GTK_THEME_DIR"

# GTK theme, icons and mouse cursor
cp -r "$INSTALLER_DIR/themes/Flat-Remix-GTK-Grey-Darkest" "$GTK_THEME_DIR/"
cp -r "$INSTALLER_DIR/icons/Flat-Remix-Grey-Dark" "$ICONS_DIR/"
cp -r "$INSTALLER_DIR/icons/Bibata-Modern-Ice" "$ICONS_DIR/"

# GTK config
cp -r "$INSTALLER_DIR/config/gtk/gtk-3.0" "$HOME/.config/"

# apply gtk and icon themes
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Grey-Darkest"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Grey-Dark"
