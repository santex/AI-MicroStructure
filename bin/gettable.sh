cat  postleitzahl.php\?plz=01445 | xargs   | sed 's/.*<table\{1\}\(.*\)\{1,\}.*.<\/table>.*$/<table\1<\/table>/'
