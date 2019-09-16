#!/bin/sh 

# Variablen aufräumen
unset url \
importdatei \
buchstaben \
exportdatei \
buchstabe

# Statische Variablen
importdatei=buchstaben_links.txt
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"

# Orte auslesen und in individuellen Dateien ablegen
for buchstabe in $buchstaben;do
	# Link für den Buchstaben aus der Import-Datei holen
	url=$(cat $importdatei | grep $buchstabe | cut -d" " -f2)

	# Export-Datei definieren
	exportdatei=""$buchstabe"_links.txt"
	# Datei leeren
	touch $exportdatei
	if [ -f $exportdatei ];then
		echo "Datei $exportdatei vorhanden"
		curl -s $url | grep bl_liste -A2 | tail -n1 | sed -e 's/<\/li>/\n/g' -e 's/<li>//g' -e 's/<a href=//g' -e 's/title=//g' -e 's/>//g' -e 's/<\/a//g' | cut -d"'" -f-4 | sed -e "s/'//g" >> $exportdatei
	else
		echo "Datei $exportdatei nicht vorhanden"
	fi
done
