#/bin/bash

CURRENT_INPUT_SOURCE=`gsettings get org.gnome.desktop.input-sources current | cut -d' ' -f2`

if [ $CURRENT_INPUT_SOURCE -eq 0 ]; then
    gsettings set org.gnome.desktop.input-sources current 1
else
    gsettings set org.gnome.desktop.input-sources current 0
fi

pkill -RTMIN+9 i3blocks
