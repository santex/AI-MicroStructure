#!/bin/bash
IFS_BAK=$IFS;
IFS=$'\n';

file=$1
#ome/santex/data-hub/steam/freq-raw.micro

array=( $(cat $file) );
array2=( $(cat "$file.last") );
A=("one" "two" "three four")

n=0;


function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}




for item in ${array[@]}
do


#echo $item


array2=( $(cat "$1.last") );

if [ $(contains "${array2[@]}" "$item") == "n" ]; then
    echo "contains not $item"

d=$(uptime |  tr " " "\n" | egrep "^([1-9]).*.[0-9]" | egrep -v ":" | tr "," "+" | tr -d "\n"); d=$(echo $d|bc);d=$(echo $d/3 | bc);


var=$(ps aux | grep -c micro-wiki-2);

echo $d $var

if  [ 8 -lt $d ];
then
killall -9 micro-wiki-2;
sleep 50
n=0;
fi

if  [ 80 -lt $var ];
then
  echo $n;
  let n+=1
  killall -9 micro-wiki-2;
  sleep 120;
  echo "wait";
else



  micro-wiki-2 $item &
  echo $item >> "$1.last"
  n=0;
  sleep 1;
fi

fi



done;
echo $n;
IFS=$IFS_BAK;

