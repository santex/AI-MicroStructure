#!/usr/bin/bash
#Microstructures on the Terminal
count=0;

#SHOW 1 RANDOM NODE
micro; echo "(returns a random node)";
#OR
perl -Micro -E "print say+microname;"



#SHOW 10 RANDOM NODES
micro any 10;
echo "(returns 10 random nodes)";
#OR
perl -Micro -E "print say+microname+10;"



#SHOW 8 RANDOM PLANETS
micro planets 8;
echo " (returns 8 random nodes from micro structure planets)";


#CREATE CHAOS
sudo micro new chaos;
echo " (creates micro structure chaos)";



#DUMP CHAOS
sudo micro drop chaos;
echo " (deletes micro structure chaos)";

#DUMP TOP NODES
perl -MAI::MicroStructure -le 'print for AI::MicroStructure->structures;'


#ITERATES TOP NODES
for i in `perl -MAI::MicroStructure -le 'print for AI::MicroStructure->structures;'`; do echo $i; done


#ITERATES ALL
for i in `perl -MAI::MicroStructure -le 'print  for AI::MicroStructure->structures';`;
do echo "@@@@@@@@@@<SET>@@@@@@@@@@@@<"$count">@@@@@@@@@<"$i">@@@@@@@@@";
count=$(expr $count + 1);
perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",",$m->name(scalar $m));
print join(",",$m->categories()); ';
done

#BUILDING A STRUCTUCRE MANUEL
for i in `cat /tmp/german-citys `; do
echo -e "\n\n";
echo "select postcode from geo.addressbook_postcodes where city='"$i"'" | mysql -u root -ppass | tr "\n" " " |  sed -s "s/^postcode/\n# names $i\n/" | sed -s "s/^ //">> ~/bin/germany.pm;   done
