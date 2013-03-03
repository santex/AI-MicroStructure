#!/usr/bin/bash
#Microstructures on the Terminal
count=0;

#SHOW 1 RANDOM NODE
micro; echo "(returns a random node)";
#OR
perl -Micro -E "print say+microname;"



#SHOW 10 RANDOM NODES
micro any 10;
echo "(returns 10 random node)";
#OR
perl -Micro -E "print say+microname+10;"



#SHOW 8 RANDOM PLANETS
micro planets 8;
echo " (returns 8 random nodes from micro structure planets)";


#CREATE CHAOS
#sudo micro new chaos;
#echo " (creates micro structure chaos)";



#DUMP CHAOS
#sudo micro drop chaos;
#echo " (deletes micro structure chaos)";

#DUMP TOP NODES
#perl -MAI::MicroStructure -le 'print for AI::MicroStructure->structures;'


#ITERATES TOP NODES
for i in `perl -MAI::MicroStructure -le 'print for AI::MicroStructure->structures;'`; do echo $i; done


#ITERATES ALL
for i in `perl -MAI::MicroStructure -le 'print  for AI::MicroStructure->structures';`;
do echo "@@@@@@@@@@<SET>@@@@@@@@@@@@<"$count">@@@@@@@@@<"$i">@@@@@@@@@";
count=$(expr $count + 1);
perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",",$m->name(scalar $m));
print join(",",$m->categories()); ';
done



for i in  `micro any 20`; do echo $i | xargs micro-wiki & done
~
mech-dump --text http://www.latest-ufo-sightings.net/p/polls.html  |  tr "P|." "\n" | tr -d "("   | tr  ")" "\n" | egrep "^[1-31]|oll \#"  | egrep -v "Support|Facebook|Google"



