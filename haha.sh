#!/bin/bash
opkg update
opkg install iptables iptables-mod-nat-extra redsocks
service redsocks stop && mv /etc/redsocks.conf /etc/redsocks.conf.bkp && cd /etc && wget https://gitlab.com/emonbhuiyan/bdix/-/raw/main/bdix.conf && mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp && cd /etc/init.d && wget https://gitlab.com/emonbhuiyan/bdix/-/raw/main/bdix && chmod +x /etc/init.d/bdix
