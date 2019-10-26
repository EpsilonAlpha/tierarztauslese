#!/bin/bash

# Variablen aufräumen
unset buchstaben \
buchstabe \
ortsid \
exportdatei \
fehlerlinks

# Statische Variablen
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"
fehlerlinks=fehlerlinks.txt

# alte Fehlersuch-Datei löschen
rm $fehlerlinks

for buchstabe in $buchstaben;do
		for link in $(cat "$buchstabe"_links.txt );do
			echo "Link ist $link"
			if [[ "$link" = "" ]]; then 
				# ortsid ermitteln für den Dateinamen hernehmen
				ortsid=$(echo "$link" \
				| tr -s ' ' \
				| tr -d '\t' \
				| grep 'h.*$' \
				| cut -d" " -f1 \
				| cut -d"/" -f6,7 \
				| sed -e "s/\///g")
				
				if [[ "$ortsid" == '' ]];then
					# Datei-Name zusammenstellen
					exportdatei=Buchstabe$buchstabe/"$ortsid"_aerzte.txt

					# Alte Textdateien aufräumen
					rm -rf Buchstabe"$buchstabe" 
					mkdir Buchstabe"$buchstabe"

					# Datei erstellen bzw. leeren
					touch "$exportdatei"

					curl -s "$link" \
					| sed "s/\t\t*//g" \
					| sed -n "/<div class=\"arzt-ergebnis-box first\">/,/<\/div>/p" \
					| grep "www\.tierarzt-onlineverzeichnis\.de\/tierarztpraxis\/" \
					| cut -d"\"" -f2,5 \
					| sed -e "s/\"  > / /g" -e "s/ <\/a>//g" \
					>> "$exportdatei"
				else
					echo "Bei Link \"$link\" kam nix rüber als ortsid außer >$ortsid<" > $fehlerlinks
					cat $fehlerlinks
					exit 1
				fi
			else
				# Generelle Fehlermeldung
				echo "Bei Link \"$link\" kam gar nix rüber" > $fehlerlinks
				
				# Leerzeile
				echo " " >> $fehlerlinks
				
				# Ergebnis nach jedem Filter
				echo "Prüfen wir die Filter:" >> $fehlerlinks
				
				# Leerzeile
				echo " " >> $fehlerlinks
				
				ortsid=$(echo "$link")
				echo "echo \$link gibt: $ortsid" >> $fehlerlinks
				
				ortsid=$(echo "$ortsid"| tr -s ' ')
				echo "plus tr -s \' \' gibt: $ortsid" >> $fehlerlinks
				
				ortsid=$(echo "$ortsid"| tr -d '\t')
				echo "plus tr -d \'\\t\' gibt: $ortsid" >> $fehlerlinks
				
				ortsid=$(echo "$ortsid"| grep 'h.*$')
				echo "plus grep \'h\.\*\$\' gibt: $ortsid" >> $fehlerlinks
				
				ortsid=$(echo "$ortsid"| cut -d" " -f1)
				echo "plus cut -d\" \" -f1 gibt: $ortsid" >> $fehlerlinks
				
				ortsid=$(echo "$ortsid"| cut -d"/" -f6,7)
				echo "plus cut -d\"/\" -f6,7 gibt: $ortsid" >> $fehlerlinks
				
				ortsid=$(echo "$ortsid"| sed -e "s/\///g")
				echo "plus sed -e \"s/\///g\" gibt: $ortsid" >> $fehlerlinks
				
				# Ausgabe der Fehlerdatei
				cat $fehlerlinks
				exit 1
			fi
		done
done
