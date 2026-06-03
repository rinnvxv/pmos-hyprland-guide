# pmos-hyprland-guide
A setup guide and dotfiles for running Hyprland on postmarketOS.

<img width="360" height="720" alt="2026-06-03_13-54-17" src="https://github.com/user-attachments/assets/cd71f474-51c3-426b-b2f8-a651f47e7c73" />

----------

1. Install postmarketOS on your device following the wiki for your device.
   - Recommended DE: Phosh — easy initial setup and allows selecting the DE from the lock screen.

2. Run the following commands:
   - Update packages: `sudo apk upgrade`
   - Install packages: `sudo apk add hyprland hyprland-protocols xwayland alacritty waybar swaybg swaync fuzzel wvkbd jq brightnessctl grim`
   - Fix brightnessctl permissions: `sudo chmod +s /usr/bin/brightnessctl`

3. Place the config files below into ~/.config.
   - fuzzel config is required for wvkbd to work inside fuzzel.

4. Log out, select Hyprland from the lock screen, and log in.
   - If Hyprland doesn't appear on the lock screen, install tinydm and try again:
     `sudo apk add tinydm`

Keybindings
- Volume Up:          Open terminal (alacritty)
- Volume Down:        Toggle virtual keyboard (wvkbd)
- Super + Enter:      Open terminal
- Super + D:          Open Menu (fuzzel)
- Super + E:          File manager (nautilus)
- Super + W:          Web browser (firefox-esr)
- Super + Q:          Close window
- Super + M:          Exit Hyprland
- Super + Shift + P: Screenshot (3s delay)
- Super + Shift + ↑↓: Adjust brightness (±5%)
- Swipe from Edge:    Change Workspace

Tested on: OnePlus 6T (fajita, SDM845) and Google Pixel 3 (blueline, SDM845).
