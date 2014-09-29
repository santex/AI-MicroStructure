#!/bin/sh

sudo killall dhclient
sudo route del default
sudo route add default 172.22.99.4 dev eth0
sudo ifconfig eth0 172.22.99.215 netmask 255.255.255.0 

