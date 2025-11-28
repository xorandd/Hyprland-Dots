#!/usr/bin/env bash

GTK_THEME_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"
INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# GTK theme, icons and mouse cursor
cp -r "$INSTALLER_DIR/themes/Flat-Remix-GTK-Grey-Darkest" "$GTK_THEME_DIR/"
cp -r "$INSTALLER_DIR/icons/Flat-Remix-Grey-Dark" "$ICONS_DIR/"
cp -r "$INSTALLER_DIR/icons/Bibata-Modern-Ice" "$ICONS_DIR/"

# GTK configs
cp -r "$INSTALLER_DIR/gtk/gtk-3.0" "$HOME/.config/"
cp -r "$INSTALLER_DIR/gtk/gtk-4.0" "$HOME/.config/"

