#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

setxkbmap saneo || exit 1

for id in $(xinput | ng "USB Keyboard" | ng -o "id=\d+" | ng -o "\d+"); do
  setxkbmap -device $id saneo_inverted || exit 1
done

xset r rate 300 65
if [[ $(hostname) == "azathoth" ]]; then
  xset m 1 2
elif [[ $(hostname) == "scabeiathrax" ]]; then
  xset m 13/10 1
else # good default
  xset m 3 2
fi

if [[ $(hostname) == "azathoth" ]]; then
  numlockx on
fi

if [[ $(hostname) == "scabeiathrax" ]]; then
  sudo ~/src/misc/apple/un-apple-keyboard/fix-apple-keyboard
fi
