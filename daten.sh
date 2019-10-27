#!/bin/bash

# Variablen aufräumen
unset buchstaben \
buchstabe \
modus

# Übergabe-Variablen
modus=$1

# Statische Variablen
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"
fehlerlinks=fehlerlinks.txt
ausgabename=daten
ausgabeendung=csv

# # alle Buchstaben-Verzeichnisse durchgehen

einzeln() {
  buchstabe="$1"
  
  if [ -f Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung ];then
    rm Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung
  fi
  
  for file in $(ls -f Buchstabe$buchstabe/*.txt);do
    # jeden Link, einen nach dem Anderen abarbeiten
    for link in $(cat "$buchstabe"_links.txt | cut -d" " -f1 | grep -e '^http.*$');do
      # Ausgabe des Links zur Diagnose
      echo "Link ist $link"
      
      curl -s $link |\
        sed -n "/<div class=\"do_adresse\">/,/<\/div>/p"  |\
        tr -s ' ' |\
        tr -d '\t' |\
        cut -d">" -f2 |\
        cut -d"<" -f1 |\
        sed -e '/^[[:space:]]*$/d' |\
        grep -vE 'Tierarztpraxis|Telefon|Mobil|Fax|E-Mail' |\
        sed -e ':a;N;$!ba;s/\n/\";\"/g' |\
        sed -e 's/^/\"/' |\
        sed -e 's/$/\"/' \
        >> Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung &
    done
  done
}

# jeden Link, einen nach dem Anderen abarbeiten und folgendes extrahieren:
# # Name
# # Strasse
# # Hausnummer
# # Telefon
# # Mobil
# # # Abfrage ob Mobilfunk leer ist
# # Fax
# # E-Mail
# # Webseite
# > diese Informationen im CSV-Format zu ./Buchstabe?/daten?.csv hinzufügen

# Alle daten?.csv's zusammenfassen

# Auswahl des Modus
case $modus in 
  #* )
  #  alles
  #;;
  A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Z )
    einzeln $modus
  ;;
esac
