#!/bin/sh

CURRENT_TRANSFORM=$(hyprctl getoption input:touchdevice:transform | grep "int:" | awk '{print $2}')

if [ "$CURRENT_TRANSFORM" = "0" ]; then
    hyprctl keyword monitor "DSI-1, preferred, auto, 2.5, transform, 3"
    hyprctl keyword input:touchdevice:transform 3
else
    hyprctl keyword monitor "DSI-1, preferred, auto, 2.5, transform, 0"
    hyprctl keyword input:touchdevice:transform 0
fi
