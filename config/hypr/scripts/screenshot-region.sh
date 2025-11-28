#!/usr/bin/env bash
# https://github.com/xorandd

time=$(date "+%d-%b_%H-%M-%S")
dir="$HOME/Pictures/Screenshots"
file="Screenshot_${time}.png"

mkdir -p "$dir"

# temporary file for selection
tmpfile=$(mktemp)

# select area and take screenshot
grim -g "$(slurp)" - > "$tmpfile"

# save and copy to clipboard if the screenshot is not empty
if [[ -s "$tmpfile" ]]; then
    mv "$tmpfile" "$dir/$file"
    wl-copy < "$dir/$file"
else
    rm "$tmpfile"
fi
