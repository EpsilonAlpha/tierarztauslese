#!/bin/sh

# Variablen aufräumen
unset url \
buchstabe \
buchstaben \
feldnummer \
burl \
dateiname

# Statische Variablen
url=https://www.tierarzt-onlineverzeichnis.de/tieraerzte/deutschland/0/
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"
feldnummer=2
dateiname=buchstaben_links.txt

# Datei leeren
touch $dateiname

for buchstabe in $buchstaben;do
	burl=$(curl -s $url | grep ">$buchstabe<" | cut -d "\"" -f$feldnummer)
	echo "$buchstabe $burl" >> $dateiname
done
