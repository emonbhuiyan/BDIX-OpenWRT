#!/bin/bash

# Update package
opkg update

#install packages
opkg install iptables iptables-mod-nat-extra redsocks

#Then run this line
service redsocks stop && service redsocks disable && cd /etc && wget https://github.com/emonbhuiyan/BDIX/raw/main/bdix.conf && cd /etc/init.d && wget https://github.com/emonbhuiyan/BDIX/raw/main/bdix && chmod +x /etc/init.d/bdix
#&& rm /etc/redsocks.conf && rm /etc/init.d/redsocks


echo -e "Thanks for installing. Follow me for more updates. https://fb.me/emoncontact"
