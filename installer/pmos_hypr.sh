#!/bin/ash
# ============================================================
#  pmos_hypr.sh
#  postmarketOS — Hyprland + hyprgrass + file selector 설치
#  target shell: ash
# ============================================================

set -e

HYPRLAND_VERSION="v0.54.3"
TEMP_DIR="$HOME/.pmos_hypr_temp"

log()  { printf '\033[1;32m[+]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$1"; exit 1; }

# 종료 시 임시 디렉토리 자동 삭제
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log "임시 디렉토리 삭제 중: $TEMP_DIR"
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# 임시 디렉토리 생성
mkdir -p "$TEMP_DIR"
log "임시 디렉토리 생성: $TEMP_DIR"

# ──────────────────────────────────────────────────────────
# 1. 시스템 업그레이드
# ──────────────────────────────────────────────────────────
log "시스템 업그레이드 중..."
sudo apk upgrade -y

# ──────────────────────────────────────────────────────────
# 2. Hyprland 및 기본 패키지 설치
# ──────────────────────────────────────────────────────────
log "Hyprland 및 기본 패키지 설치 중..."
sudo apk add -y \
    hyprland hyprland-protocols xwayland \
    alacritty waybar swaybg swaync fuzzel \
    wvkbd jq brightnessctl grim tinydm \
    swaylock font-awesome font-jetbrains-mono-nerd

sudo chmod +s /usr/bin/brightnessctl

# ──────────────────────────────────────────────────────────
# 3. xdg-desktop-portal (파일 선택창) 설치
# ──────────────────────────────────────────────────────────
log "xdg-desktop-portal 설치 중..."
sudo apk add -y \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

log "xdg-desktop-portal 설정 파일 생성 중..."
mkdir -p "$HOME/.config/xdg-desktop-portal"
printf '[preferred]\ndefault=hyprland;gtk\norg.freedesktop.impl.portal.FileChooser=gtk\n' \
    > "$HOME/.config/xdg-desktop-portal/portals.conf"

# ──────────────────────────────────────────────────────────
# 4. hyprpm 빌드 의존성 설치
# ──────────────────────────────────────────────────────────
log "hyprpm 빌드 의존성 설치 중..."
sudo apk add -y \
    git cmake make g++ meson \
    cpio mesa-dev libxcb-dev xcb-util-wm-dev \
    pixman-dev libdrm-dev wayland-protocols wayland-dev \
    libinput-dev libxkbcommon-dev pango-dev cairo-dev \
    libxcursor-dev re2-dev muparser-dev \
    hyprwire hyprwayland-scanner \
    python3 pkgconf

# ──────────────────────────────────────────────────────────
# 5. hyprwire 소스 빌드 (pkg-config 파일 없을 경우 대비)
# ──────────────────────────────────────────────────────────
if ! pkg-config --modversion hyprwire > /dev/null 2>&1; then
    log "hyprwire pkg-config 없음 — 소스에서 빌드 중..."
    cd "$TEMP_DIR"
    git clone https://github.com/hyprwm/hyprwire
    cd hyprwire
    cmake -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build -j$(nproc)
    sudo cmake --install build
    cd "$TEMP_DIR"
fi

# ──────────────────────────────────────────────────────────
# 6. Hyprland 소스 클론 및 hyprpm 빌드
# ──────────────────────────────────────────────────────────
log "Hyprland 소스 클론 중... ($HYPRLAND_VERSION)"
cd "$TEMP_DIR"
git clone https://github.com/hyprwm/Hyprland
cd Hyprland
git checkout "$HYPRLAND_VERSION"
git submodule update --init subprojects/udis86

log "hyprpm 빌드 중..."
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target hyprpm -j$(nproc)

log "hyprpm 설치 중..."
sudo cmake --install build --component hyprpm

# PATH에 없는 경우 수동 복사
if ! command -v hyprpm > /dev/null 2>&1; then
    warn "hyprpm이 PATH에 없습니다. /usr/local/bin에 복사합니다."
    sudo cp "$TEMP_DIR/Hyprland/build/hyprpm/hyprpm" /usr/local/bin/
    sudo chmod +x /usr/local/bin/hyprpm
fi

export PATH="/usr/local/bin:$PATH"
command -v hyprpm > /dev/null 2>&1 || die "hyprpm 설치 실패"
log "hyprpm 설치 완료"

# ──────────────────────────────────────────────────────────
# 7. hyprgrass 설치
# ──────────────────────────────────────────────────────────
log "hyprgrass 설치 중..."
hyprpm update
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm enable hyprgrass

# ──────────────────────────────────────────────────────────
# 8. dotfiles 다운로드
# ──────────────────────────────────────────────────────────
log "dotfiles 다운로드 중..."
cd "$TEMP_DIR"
git clone https://github.com/rinnvxv/pmos-hyprland-guide repo 2>/dev/null || {
    warn "repo 클론 실패 — 수동으로 복사해주세요."
}

if [ -d "$TEMP_DIR/repo/installer/config" ]; then
    mkdir -p "$HOME/.config"
    cp -r "$TEMP_DIR/repo/installer/config/." "$HOME/.config/"
    log "dotfiles 복사 완료 → ~/.config/"
fi

# ──────────────────────────────────────────────────────────
# 완료 (cleanup trap이 TEMP_DIR 자동 삭제)
# ──────────────────────────────────────────────────────────
log "========================================"
log "설치 완료!"
log ""
log "재부팅 후 TinyDM에서 Hyprland를 선택하세요."
log ""
log "[파일 선택창] 재부팅 시 자동 시작됩니다."
log "수동으로 띄우려면:"
log "  /usr/libexec/xdg-desktop-portal &"
log "  /usr/libexec/xdg-desktop-portal-hyprland &"
log "========================================"
