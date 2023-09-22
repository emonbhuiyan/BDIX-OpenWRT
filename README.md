# BDIX Redsocks OpenWRT
BDIX bypass become very popular in Bangladesh, especially in rural and urban areas. Socks5 is one of the popular proxy protocols here. What we could use socks5 proxy on our router? Yeah, we can use socks5 proxy on the OpenWRT router. However, I found a very rare tutorial about how to configure socks5 proxy on an OpenWRT router. With this tutorial, we can use it on our OpenWRT router easily. To install and configure socks5 proxy, ensure you have installed OpenWrt on your router. Then run commands as follows:

# One command run installation
Run the following command to install BDIX proxy extension automatically:
```
cd /tmp && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/install.sh && chmod +x install.sh && clear && sh install.sh && rm install.sh && cd / && clear
```
Just run it and wait for completion. And enjoy. <!-- [Click here to learn step by step manual installation](#manual-installation-step-by-step) -->

## To update proxy IP, Port, Username & Password
```
vi /etc/bdix.conf
```
After the update press `esc` key then `:wq` to save or `:q!` to discard changes

<img src="https://i.imgur.com/SPPiuBd.png" alt="Update proxy IP, Port, Username & Password" width="500"/>

# How to start and stop BDIX:

### To start BDIX proxy bypass
```
service bdix start
```

### To stop BDIX proxy bypass
```
service bdix stop
```

### To restart BDIX proxy bypass
```
service bdix restart
```

### To enable BDIX auto boot-start proxy
```
service bdix enable
```

### To disable BDIX auto boot-start proxy
```
service bdix disable
```
<!--
Manual installation step by step:
=
### Step 1: Update your package manager
```
opkg update
```

### Step 2: Install these 3 packages
```
opkg install iptables iptables-mod-nat-extra redsocks
```

### Step 3: Then run this line
```
service redsocks stop && mv /etc/redsocks.conf /etc/redsocks.conf.bkp && cd /etc && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/bdix.conf && mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp && cd /etc/init.d && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/bdix && chmod +x /etc/init.d/bdix
```
[Click here to install with one command run](#one-command-run-installation)
-->

Thanks for following my tutorial. Follow me to get more interesting tips and tricks.
