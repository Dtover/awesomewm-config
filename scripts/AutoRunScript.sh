#!/bin/bash
# Keys remap
xmodmap ~/.Xmodmap
# Set up multiple screens
monitor_num=$(xrandr --listmonitors | awk '/^Mon/{print $2}')
if [[ $monitor_num == 2 ]];then
	xrandr --output DP1 --right-of eDP1 --auto
	xrandr --output DP1 --rotate right --auto
	xrandr --output eDP1 --pos 0x720
fi
# Set touchpad scroll direction and tap click
touchpad_id=$(xinput list | grep "Touchpad" | cut -d '=' -f2 | awk '{print $1}')
natural_scrolling_id=`xinput list-props $touchpad_id | grep "Natural Scrolling Enabled (" | cut -d'(' -f2 | cut -d')' -f1`
tap_to_click_id=`xinput list-props $touchpad_id | grep "Tapping Enabled (" | cut -d'(' -f2 | cut -d')' -f1`
xinput --set-prop $touchpad_id $natural_scrolling_id 1
xinput --set-prop $touchpad_id $tap_to_click_id 1
# Disable touch screen
touchscreen_id=$(xinput list | grep "Finger" | cut -d '=' -f2 | awk '{print $1}')
xinput --set-prop $touchscreen_id "Device Enabled" 0
# Other setting
pulseaudio --daemonize
xset -dpms
xset s 3600 3600
#xautolock -time 15 -locker i3lock-fancy &
xautolock -time 15 -locker btlock &
