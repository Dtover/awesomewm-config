#!/bin/bash
xmodmap ~/.Xmodmap
touchpad_id=$(xinput list | grep "Touchpad" | cut -d '=' -f2 | awk '{print $1}')
natural_scrolling_id=`xinput list-props $touchpad_id | grep "Natural Scrolling Enabled (" | cut -d'(' -f2 | cut -d')' -f1`
tap_to_click_id=`xinput list-props $touchpad_id | grep "Tapping Enabled (" | cut -d'(' -f2 | cut -d')' -f1`
xinput --set-prop $touchpad_id $natural_scrolling_id 1
xinput --set-prop $touchpad_id $tap_to_click_id 1
