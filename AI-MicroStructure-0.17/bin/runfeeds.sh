mkdir /var/www/countrys/;
 for i in `ls  . |  egrep -v "(-|_|^[a-b|A-B])" `;
 do
 x=$i;
 y="";
 z="";
  echo $i  ;
 echo "<pre>" > "/var/www/countrys/"$x"_"$y"_"$z".html";
 perl ~/grinder/intersec.pl  /mnt/ramdisk/archive/mufon_json/stored.cng $x >> "/var/www/countrys/"$x"_"$y"_"$z".html" ;
 done
