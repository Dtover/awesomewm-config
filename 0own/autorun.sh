#!/bin/bash
function run {
	if ! pgrep -f $1;then
		$@&
	fi
}
run ${HOME}/.config/awesome/AutoRunScript.sh
run fcitx 
#run dunst
run utools

