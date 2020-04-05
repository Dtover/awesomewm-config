#!/bin/bash
if [[ -f ~/Desktop/DailyTODO/"$(date '+%m_%d')" ]];then
		notify-send "$(cat ~/Desktop/DailyTODO/"$(date '+%m_%d')")" 
	else
		notify-send "NO LIST FOUND ! 
Please press mod+;t build one!"
fi
