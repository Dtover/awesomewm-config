#!/bin/bash
notify-send "Most memmory usage:
$(ps axch -o cmd:15,%mem --sort=-%mem | head)"
