#/bin/bash

CURRENT_INPUT_SOURCE=`gsettings get org.gnome.desktop.input-sources current | cut -d' ' -f2`
INPUT_SOURCE=$((CURRENT_INPUT_SOURCE ^= 1))
gsettings set org.gnome.desktop.input-sources current $INPUT_SOURCE

pkill -RTMIN+9 i3blocks
