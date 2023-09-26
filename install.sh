#!/bin/bash

# Update package
opkg update

#install packages
opkg install iptables iptables-mod-nat-extra redsocks

#Then run this line
service redsocks stop && mv /etc/redsocks.conf /etc/redsocks.conf.bkp && cd /etc && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/bdix.conf && mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp && cd /etc/init.d && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/bdix && chmod +x /etc/init.d/bdix

cd /
clear


echo -e "Thanks for installing. Follow me for more updates: https://fb.me/emoncontact"
