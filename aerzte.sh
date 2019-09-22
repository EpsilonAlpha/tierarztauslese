#!/bin/sh 

# Variablen aufräumen
unset buchstaben \
buchstabe \
ortsid \
exportdatei \
fehlerlinks

# Statische Variablen
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"
fehlerlinks=fehlerlinks.txt

for buchstabe in $buchstaben;do
		for link in $(cat "$buchstabe"_links.txt );do
			if [ $link == '' ]; then 
				# ortsid ermitteln für den Dateinamen hernehmen
				ortsid=$(echo "$link" | cut -d" " -f1 | cut -d"/" -f6,7 | sed -e "s/\///g")
				if [ $ortsid == '' ];then
					# Datei-Name zusammenstellen
					exportdatei="Buchstabe"$buchstabe"/"$ortsid"_aerzte.txt"

					# Alte Textdateien aufräumen
					cd "Buchstabe$buchstabe";rm *.txt; cd ..

					# Datei erstellen bzw. leeren
					touch $exportdatei

					curl -s "$link" \
					| sed "s/\t\t*//g" \
					| sed -n "/<div class=\"arzt-ergebnis-box first\">/,/<\/div>/p" \
					| grep "www\.tierarzt-onlineverzeichnis\.de\/tierarztpraxis\/" \
					| cut -d"\"" -f2,5 \
					| sed -e "s/\"  > / /g" -e "s/ <\/a>//g" \
					>> $exportdatei
				else
					echo "Bei Link \"$link\" kam nix rüber als ortsid" > $fehlerlinks
					exit 1
				fi
			else
				echo "Bei Link \"$link\" kam gar nix rüber" > $fehlerlinks
				exit 1
			fi
		done
done
