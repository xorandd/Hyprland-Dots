#!/usr/bin/env bash
# https://github.com/xorandd

BRIGHT_RED=$(tput setaf 1)
BRIGHT_GREEN=$(tput setaf 2)
BRIGHT_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$1" =~ ^[Nn]$ ]]; then
    echo "${BRIGHT_YELLOW}[*]${RESET} Skipping GRUB theme installation..."
    exit 0
fi

THEME_SRC="$INSTALLER_DIR/themes/grub_theme/minimal"
THEME_DEST="/boot/grub/themes/minimal"

# create destination folder
sudo mkdir -p "$THEME_DEST"

# copy theme
echo "${BRIGHT_YELLOW}[*]${RESET} Copying GRUB theme..."
sudo cp -r "$THEME_SRC/"* "$THEME_DEST/"

# update /etc/default/grub
GRUB_CONFIG="/etc/default/grub"
if grep -q '^GRUB_THEME=' "$GRUB_CONFIG"; then
    sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$THEME_DEST/theme.txt\"|" "$GRUB_CONFIG"
else
    echo "GRUB_THEME=\"$THEME_DEST/theme.txt\"" | sudo tee -a "$GRUB_CONFIG" >/dev/null
fi

# generate grub config to apply theme
echo "${BRIGHT_YELLOW}[*]${RESET} Regenerating GRUB config..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "${BRIGHT_GREEN}[+]${RESET} GRUB theme installed successfully!"
