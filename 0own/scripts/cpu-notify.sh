#!/bin/bash
notify-send "Most cpu usage:
$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)"
