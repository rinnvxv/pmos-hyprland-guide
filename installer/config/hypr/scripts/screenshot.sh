#!/bin/sh

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

FILE_NAME="$(date +%Y-%m-%d_%H-%M-%S).png"
FULL_PATH="$SAVE_DIR/$FILE_NAME"

grim "$FULL_PATH"

if [ -f "$FULL_PATH" ]; then
    notify-send -i "$FULL_PATH" "Scrennshot Captured" "$FILE_NAME"
fi
