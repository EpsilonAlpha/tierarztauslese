#!/bin/sh 

# Variablen aufräumen
unset buchstaben \
buchstabe \
ortsid \
exportdatei

# Statische Variablen
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"

for buchstabe in $buchstaben;do
	for ortsid in $(cat "$buchstabe"_links.txt | cut -d" " -f1 | cut -d"/" -f6,7 | sed -e "s/\///g");do
		
		# Datei-Name zusammenstellen
		exportdatei="Buchstabe"$buchstabe"/"$ortsid"_aerzte.txt"

		# Datei erstellen bzw. leeren
		touch $exportdatei
	done
done
