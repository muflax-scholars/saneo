#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

for txt in ibus/*.txt; do
  db="ibus/${txt:t:r}.db"
  ibus-table-createdb -s $txt -n $db  -d
  /bin/cp -v $db /usr/share/ibus-table/tables/
done

ibus-daemon --xim --replace --daemonize
