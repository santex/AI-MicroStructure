find . -name '*.$1' -type f -exec sed -i 's/$2/$3/' {} \;
