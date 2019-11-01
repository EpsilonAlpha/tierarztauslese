#!/bin/bash

# Variablen aufräumen
unset buchstaben \
buchstabe \
modus

# Übergabe-Variablen
modus=$1

# Statische Variablen
buchstaben="A B C D E F G H I J K L M N O P Q R S T U V W X Z"
workdir=/root/tierarztauslese
fehlerlinks=fehlerlinks.txt
ausgabename=daten
ausgabeendung=csv

# # alle Buchstaben-Verzeichnisse durchgehen

einzeln() {
  buchstabe="$1"
  
  #if [ -f Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung ];then
  #  rm Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung
  #fi
  
  #for file in $(ls -f Buchstabe$buchstabe/*.txt);do
    # jeden Link, einen nach dem Anderen abarbeiten
    for link in $(cat $workdir/"$buchstabe"_links.txt | cut -d" " -f1 | grep -e '^http.*$' | head -1 );do
      # Ausgabe des Links zur Diagnose
      echo "Link ist $link";
      
      ausgabe=$(curl -s $link |\
      ausgabe=$(echo $ausgabe | sed -n '/<div class=\"do_adresse\">/,/<\/div>/p');
      ausgabe=$(echo $ausgabe | tr -s ' ')
      ausgabe=$(echo $ausgabe | tr -d '\t')
      ausgabe=$(echo $ausgabe | cut -d">" -f2)
      ausgabe=$(echo $ausgabe | cut -d"<" -f1)
      ausgabe=$(echo $ausgabe | sed -e '/^[[:space:]]*$/d')
      ausgabe=$(echo $ausgabe | grep -vE 'Tierarztpraxis|Telefon|Mobil|Fax|E-Mail')
      ausgabe=$(echo $ausgabe | sed -e ':a;N;$!ba;s/\n/\";\"/g')
      ausgabe=$(echo $ausgabe | sed -e 's/^/\"/')
      ausgabe=$(echo $ausgabe | sed -e 's/$/\"/')
      echo $ausgabe
      #>> Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung &
    done
  #done
  
  #if [ -f Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung ];then
  #  echo "Der Inhalt von $ausgabename$buchstabe.$ausgabeendung ist:";
    # Das Ergebnis ausgeben
  #  cat Buchstabe$buchstabe/$ausgabename$buchstabe.$ausgabeendung;
  #else
  #  echo "Die Datei $ausgabename$buchstabe.$ausgabeendung ist nicht vorhanden!";
  #fi
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
