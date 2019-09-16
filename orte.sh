#!/bin/sh

# Variablen aufräumen
unset url \
dateiname

# Statische Variablen
dateiname=buchstaben_links.txt
url=$(cat $dateiname | head -n1 | cut -d" " -f2)

curl -s $url | \
grep bl_liste -A2 | \
tail -n1 | \
sed -e 's/<\/li>/\n/g' \
-e 's/<li>//g' \
-e 's/<a href=//g' \
-e 's/title=//g' \
-e 's/>//g' \
-e 's/<\/a//g'