#!/bin/bash
# This script is used to change the background image  
path="/home/dtover/Pictures/BG_images/"
num=$(ls $path | wc -l)
let image="$[$RANDOM%100]"
until [[ $image -le $num && $image -gt 0 ]]
do
	let image="$[$RANDOM%100]"
done
PI="$(ls $path | grep $image)"
/home/dtover/.local/selfbin/setbg $path$PI 2> /dev/null;
	
