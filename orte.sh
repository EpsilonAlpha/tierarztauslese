#!/bin/sh

# Variablen aufräumen
unset url \
importdatei \
buchstaben

# Statische Variablen
importdatei=buchstaben_links.txt
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"


for buchstabe in $buchstaben;do
    url=$(cat $importdatei | grep $buchstabe | cut -d" " -f2)

    curl -s $url | \
    grep bl_liste -A2 | \
    tail -n1 | \
    sed -e 's/<\/li>/\n/g' \
    -e 's/<li>//g' \
    -e 's/<a href=//g' \
    -e 's/title=//g' \
    -e 's/>//g' \
    -e 's/<\/a//g' | \
    cut -d"'" -f-4 | \
    sed -e "s/'//g"
done