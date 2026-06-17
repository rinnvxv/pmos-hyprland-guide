#!/bin/sh
hyprpm update
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm enable hyprgrass

sed -i '/install_hyprgrass\.sh/d' ~/.config/hypr/hyprland.conf
