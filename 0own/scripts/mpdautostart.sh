#!/bin/sh
# This script run mpd and config mpc
mpd 2> /dev/null;
mpc add CloudMusic > /dev/null;
mpc random on;
