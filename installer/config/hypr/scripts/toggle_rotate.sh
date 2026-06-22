#!/bin/sh

# 현재 터치 디바이스의 transform 값(숫자)을 가져옵니다.
CURRENT_TRANSFORM=$(hyprctl getoption input:touchdevice:transform | grep "int:" | awk '{print $2}')

if [ "$CURRENT_TRANSFORM" = "0" ]; then
    # 0이면 3으로 전환
    hyprctl keyword monitor "DSI-1, preferred, auto, 2.5, transform, 3"
    hyprctl keyword input:touchdevice:transform 3
else
    # 3(또는 그 외)이면 0으로 전환
    hyprctl keyword monitor "DSI-1, preferred, auto, 2.5, transform, 0"
    hyprctl keyword input:touchdevice:transform 0
fi
