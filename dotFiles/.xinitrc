#!/bin/sh

[ -f "$HOME/.Xresources" ] && xrdb -merge -I$HOME ~/.Xresources
[ -f "$HOME/.fehbg" ] && ~/.fehbg &

exec i3

