# Hyprland + Hyprgrass Installation Script for postmarketOS

Tested on a Google Pixel 3 (blueline).

---

## How to Run

$ `sudo -v && curl -fsSL https://raw.githubusercontent.com/rinnvxv/pmos-hyprland-guide/main/installer/pmos_hypr.sh | sh`

## Keybinds
- Volume Up:          Open application launcher (fuzzel)
- Volume Down:        Toggle virtual keyboard (wvkbd)
- Super + Enter:      Open terminal
- Super + D:          Open application launcehr
- Super + E:          File manager (nautilus)
- Super + W:          Web browser (firefox-esr)
- Super + Q:          Close window
- Super + M:          Exit Hyprland
- Super + Shift + P: Screenshot (3s delay)
- Super + Shift + ↑↓: Adjust brightness (±10%)

## Gesture Configuration

### Three-Finger Gestures

- Swipe down: Launch terminal
- Swipe up: Launch browser
- Tap: Close the currently focused window
- Long press: Turn off the screen
- Pinch out: Take a screenshot
- Swipe edge: Change workspaces

### Four-Finger Gestures

- Tap: Screen Rotate
- Long press: Exit Hyprland

### Edge Gestures

- Swipe down from the top edge: Toggle fullscreen
- Swipe up from the bottom edge: Toggle floating mode

## Hardware Keys

- Volume Up: Open application launcher
- Volume Down: Toggle virtual keyboard

## Notes

- I recommend selecting `Phosh` as the desktop environment during `pmbootstrap init`.
- If you encounter DNS-related errors while running the script, try running it again. The script temporarily switches DNS to "8.8.8.8" as a workaround, but DNS issues may still occur occasionally.
