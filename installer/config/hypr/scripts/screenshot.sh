#!/bin/sh

# 저장할 폴더 생성
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# 파일명 및 전체 경로 설정
FILE_NAME="$(date +%Y-%m-%d_%H-%M-%S).png"
FULL_PATH="$SAVE_DIR/$FILE_NAME"

# 1. 스크린샷 캡처
grim "$FULL_PATH"

# 2. 캡처 성공 시 swaync로 알림 전송 (-i 옵션으로 미리보기 썸네일 표시)
if [ -f "$FULL_PATH" ]; then
    notify-send -i "$FULL_PATH" "Scrennshot Captured" "$FILE_NAME"
fi
