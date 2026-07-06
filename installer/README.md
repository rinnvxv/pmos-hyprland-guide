# Hyprland + Hyprgrass Installation Script for postmarketOS

Tested on a Google Pixel 3 (blueline).

---

## How to Run

$ `sudo -v && curl -fsSL https://raw.githubusercontent.com/rinnvxv/pmos-hyprland-guide/main/installer/pmos_hypr.sh | sh`

## Gesture Configuration

### Three-Finger Gestures

- Swipe down: Launch terminal ("alacritty")
- Swipe up: Launch browser ("firefox-esr")
- Tap: Close the currently focused window
- Long press: Turn off the screen
- Pinch out: Take a screenshot

### Four-Finger Gestures

- Tap: Screen Rotate
- Long press: Exit Hyprland

### Edge Gestures

- Swipe down from the top edge: Toggle fullscreen
- Swipe up from the bottom edge: Toggle floating mode

## Hardware Keys

- Volume Up: Open application launcher ("fuzzel")
- Volume Down: Toggle virtual keyboard ("wvkbd")

## Notes

- I recommend selecting Phosh as the desktop environment during "pmbootstrap init".
- If you encounter DNS-related errors while running the script, try running it again. The script temporarily switches DNS to "8.8.8.8" as a workaround, but DNS issues may still occur occasionally.
