#!/bin/sh
echo "Installing hyprgrass..."
hyprpm update
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm enable hyprgrass
echo "hyprgrass installed! This window will close in 3 seconds."
sleep 3

sed -i '/install_hyprgrass\.sh/d' ~/.config/hypr/hyprland.conf

rm -rf ~/.config/hypr/scripts
