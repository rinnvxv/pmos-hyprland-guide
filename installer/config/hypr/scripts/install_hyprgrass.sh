#!/bin/sh
RESOLV_BACKUP=$(cat /etc/resolv.conf)

echo "[+] Installing hyprgrass..."
hyprpm update || {
    echo "[!] hyprpm update failed — setting DNS to 8.8.8.8 and retrying..."
    printf 'nameserver 8.8.8.8\n' | sudo tee /etc/resolv.conf > /dev/null
    hyprpm update
}

hyprpm add -y https://github.com/horriblename/hyprgrass || {
    printf 'nameserver 8.8.8.8\n' | sudo tee /etc/resolv.conf > /dev/null
    hyprpm add -y https://github.com/horriblename/hyprgrass
}

hyprpm enable hyprgrass

# DNS 복원
printf '%s\n' "$RESOLV_BACKUP" | sudo tee /etc/resolv.conf > /dev/null
echo "[+] DNS restored"

# hyprland.conf에서 이 줄 제거 (터미널 두 개 열리는 문제 해결)
sed -i '/install_hyprgrass\.sh/d' ~/.config/hypr/hyprland.conf

echo "[+] hyprgrass installed! This window will close in 3 seconds."
sleep 3

# scripts 폴더 삭제 후 터미널 종료
rm -rf ~/.config/hypr/scripts
hyprctl dispatch killactive
