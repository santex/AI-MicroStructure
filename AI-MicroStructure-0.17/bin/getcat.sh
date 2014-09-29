#!/bin/bash

IFS=$'\n'
urldecode(){
  echo -e "$(sed 's/+/ /g; s/%/\\x/g')"
}
CYAN=`tput setaf 6`
NORMAL=`tput sgr0`
REVERSE=`tput smso`

echo -e  "$REVERSE $1 $NORMAL";
echo $MICRO_LANG;
if [ ! $MICRO_LANG ]
 then
  MICRO_LANG=en
fi
search=$1;
search=$(perl -e "print ucfirst($search)");
nogo="http:\/\/|Articles|Artikel|Wikipedia|Commons|Tracking_|Hidden_|Talk_|_talk|Use_dmy_dates|_Diskussion|Pages_containing "
search=$(perl -e "print ucfirst($search)");
echo $search
function getcat(){
q="http://$MICRO_LANG.wikipedia.org/wiki/$1";

for i in `mojo get "$q" a  attr href   | egrep "^\/wiki\/(Category|Kategorie)" | egrep -vi "("$nogo")" |   sort | sed -s "s/\/wiki\///"`; do q=$i;   echo $i | urldecode; done
}
qq=$(echo "$search" | sed "s/^.*.://" | tr "_" "|");
#q=$1; cat=$(for i in `getcat "$q"`; do getcat "$i"; done); echo "$cat" | data-freq | egrep -v "http" |  sed -s "s/^.*.: //" | egrep -i "($qq)"
q=$1; cat=$(for i in `getcat "$q"`; do qq=$(echo "$q" | sed -s "s/^.*.\://");  getcat "$i"; done);    echo "$cat" | egrep -vi "http:" | data-freq | sort -n
echo -e "\n"
