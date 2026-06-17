#!/bin/sh
RESOLV_BACKUP=$(cat /etc/resolv.conf)

echo "[+] Installing hyprgrass..."
hyprpm update || {
    echo "[!] hyprpm update failed — setting DNS to 8.8.8.8 and retrying..."
    printf 'nameserver 8.8.8.8\n' | sudo tee /etc/resolv.conf > /dev/null
    hyprpm update
}

echo "y" | hyprpm add -v https://github.com/horriblename/hyprgrass || {
    printf 'nameserver 8.8.8.8\n' | sudo tee /etc/resolv.conf > /dev/null
    echo "y" | hyprpm add -v https://github.com/horriblename/hyprgrass
}

hyprpm enable hyprgrass

printf '%s\n' "$RESOLV_BACKUP" | sudo tee /etc/resolv.conf > /dev/null
echo "[+] DNS restored"

sed -i '/install_hyprgrass\.sh/d' ~/.config/hypr/hyprland.conf

echo "[+] hyprgrass installed! This window will close in 3 seconds."
sleep 3

rm -rf ~/.config/hypr/scripts
hyprctl dispatch killactive
