#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

setxkbmap saneo

xmodmap ~/.Xmodmap

xset r rate 300 65
if [[ $(hostname) == "azathoth" ]]; then
    xset m 1 2
else # good default
    xset m 3 2
fi

if [[ $(hostname) == "azathoth" ]]; then
    numlockx on
fi
