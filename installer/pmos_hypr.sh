#!/bin/ash
# ============================================================
#  Scripts for Hyprland install to postmarketOS
#  postmarketOS — Hyprland + Hyprgrass
# ============================================================

set -e

TEMP_DIR="$HOME/.pmos_hypr_temp"

log()  { printf '\033[1;32m[+]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$1"; exit 1; }

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log "Cleaning up temp directory: $TEMP_DIR"
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

mkdir -p "$TEMP_DIR"
log "Created temp directory: $TEMP_DIR"

# ──────────────────────────────────────────────────────────
# 1. System upgrade
# ──────────────────────────────────────────────────────────
log "Upgrading system..."
sudo apk upgrade || warn "System upgrade failed (package conflict) — continuing anyway..."

# ──────────────────────────────────────────────────────────
# 2. Hyprland & base packages
# ──────────────────────────────────────────────────────────
log "Installing Hyprland and base packages..."
sudo apk add --no-interactive \
    hyprland hyprland-protocols xwayland \
    alacritty waybar swaybg swaync fuzzel \
    wvkbd jq brightnessctl grim tinydm \
    swaylock font-awesome font-jetbrains-mono-nerd

sudo chmod +s /usr/bin/brightnessctl

HYPRLAND_VERSION="v$(apk info hyprland 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
[ -z "$HYPRLAND_VERSION" ] && die "Failed to detect Hyprland version"
log "Detected Hyprland version: $HYPRLAND_VERSION"

# ──────────────────────────────────────────────────────────
# 3. xdg-desktop-portal (file selector)
# ──────────────────────────────────────────────────────────
log "Installing xdg-desktop-portal..."
sudo apk add --no-interactive \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

log "Creating xdg-desktop-portal config..."
mkdir -p "$HOME/.config/xdg-desktop-portal"
printf '[preferred]\ndefault=hyprland;gtk\norg.freedesktop.impl.portal.FileChooser=gtk\n' \
    > "$HOME/.config/xdg-desktop-portal/portals.conf"

# ──────────────────────────────────────────────────────────
# 4. hyprpm build dependencies
# ──────────────────────────────────────────────────────────
log "Installing hyprpm build dependencies..."
sudo apk add --no-interactive \
    git cmake make g++ meson \
    cpio mesa-dev libxcb-dev xcb-util-wm-dev \
    pixman-dev libdrm-dev wayland-protocols wayland-dev \
    libinput-dev libxkbcommon-dev pango-dev cairo-dev \
    libxcursor-dev re2-dev muparser-dev \
    hyprwire hyprwayland-scanner pugixml-dev hyprutils-dev aquamarine-dev \
    hyprlang-dev hyprcursor-dev hyprgraphics-dev xcb-util-errors-dev tomlplusplus-dev \
    python3 pkgconf glm-dev glibmm-dev pulseaudio-dev

# ──────────────────────────────────────────────────────────
# 5. Build hyprwire from source (if pkg-config not found)
# ──────────────────────────────────────────────────────────
if ! pkg-config --modversion hyprwire > /dev/null 2>&1; then
    log "hyprwire pkg-config not found — building from source..."
    cd "$TEMP_DIR"
    git clone https://github.com/hyprwm/hyprwire
    cd hyprwire
    cmake -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build -j$(nproc)
    sudo cmake --install build
    cd "$TEMP_DIR"
fi

# ──────────────────────────────────────────────────────────
# 6. Clone Hyprland source & build hyprpm
# ──────────────────────────────────────────────────────────
log "Cloning Hyprland source... ($HYPRLAND_VERSION)"
cd "$TEMP_DIR"
RESOLV_BACKUP=$(cat /etc/resolv.conf)
git clone https://github.com/hyprwm/Hyprland || {
    warn "git clone failed — setting DNS to 8.8.8.8 and retrying..."
    printf 'nameserver 8.8.8.8
' | sudo tee /etc/resolv.conf > /dev/null
    git clone https://github.com/hyprwm/Hyprland || die "git clone failed even after DNS change"
    printf '%s
' "$RESOLV_BACKUP" | sudo tee /etc/resolv.conf > /dev/null
    log "DNS restored"
}
cd Hyprland
git checkout "$HYPRLAND_VERSION"
git submodule update --init subprojects/udis86

log "Building hyprpm..."
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target hyprpm -j$(nproc)

log "Installing hyprpm..."
sudo cmake --install build --component hyprpm

if ! command -v hyprpm > /dev/null 2>&1; then
    warn "hyprpm not in PATH — copying to /usr/local/bin..."
    sudo cp "$TEMP_DIR/Hyprland/build/hyprpm/hyprpm" /usr/local/bin/
    sudo chmod +x /usr/local/bin/hyprpm
fi

export PATH="/usr/local/bin:$PATH"
command -v hyprpm > /dev/null 2>&1 || die "hyprpm installation failed"
log "hyprpm installed successfully"

# ──────────────────────────────────────────────────────────
# 7. Download & apply dotfiles
# ──────────────────────────────────────────────────────────
log "Downloading dotfiles..."
cd "$TEMP_DIR"
git clone https://github.com/rinnvxv/pmos-hyprland-guide repo || {
    warn "Failed to clone repo — please copy dotfiles manually."
}

if [ -d "$TEMP_DIR/repo/installer/config" ]; then
    mkdir -p "$HOME/.config"
    cp -r "$TEMP_DIR/repo/installer/config/." "$HOME/.config/"
    log "Dotfiles applied → ~/.config/"
    # Set permission to install_hyprgrass.sh
    if [ -f "$HOME/.config/hypr/scripts/install_hyprgrass.sh" ]; then
        chmod +x "$HOME/.config/hypr/scripts/install_hyprgrass.sh"
        log "Permissions set for install_hyprgrass.sh"
    fi
else
    warn "installer/config not found in repo — skipping dotfiles."
fi

# ──────────────────────────────────────────────────────────
# Done (cleanup trap removes TEMP_DIR automatically)
# ──────────────────────────────────────────────────────────
log "========================================"
log "Installation complete!"
log ""
log "Reboot After 5 sec and select Hyprland in LockScreen."
log ""
log "[hyprgrass] On your first Hyprland boot,"
log "hyprgrass will be installed automatically"
log "for touch gesture support."
log "========================================"

sleep 5
sudo reboot
