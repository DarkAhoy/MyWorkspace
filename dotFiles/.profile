#!/bin/sh

export EDITOR="nano"
export TERMINAL="st"

# start the graphical interface if not alreay up
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 > /dev/null && exec startx
