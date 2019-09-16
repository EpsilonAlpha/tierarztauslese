#!/bin/sh

# Variablen aufräumen
unset url \
dateiname

# Statische Variablen
dateiname=buchstaben_links.txt
url=$(cat $dateiname | head -n1 | cut -d" " -f2)

curl -s $url | grep bl_liste -A2 | tail -n1