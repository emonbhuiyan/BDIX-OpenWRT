# BDIX Redsocks OpenWRT
Redsocks is a proxy tunneling extension. However, I found a very rare tutorial about how to configure Redsocks on an OpenWRT router. With this tutorial, we can use it on our OpenWRT router easily. It will be helpful for BDIX bypass users of Bangladesh who are using the socks5 proxy. To install and configure Redsocks, ensure you have installed OpenWrt on your router. Then run commands as follows:

# One command run installation
Run the following command to install BDIX proxy extension automatically:
```
cd /tmp && wget https://github.com/emonbhuiyan/BDIX/raw/main/install.sh && chmod +x install.sh && clear && sh install.sh && rm install.sh && cd / && clear
```
Just run it and wait for completion. And enjoy. [Click here to learn step by step manual installation](#manual-installation-step-by-step)

## To update proxy IP, Port, Username & Password
```
vi /etc/bdix.conf
```
After the update press `ESC` key then `:wq` to save or `:q!` to discard changes

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
service redsocks stop && service redsocks disable && cd /etc && wget https://github.com/emonbhuiyan/BDIX/raw/main/bdix.conf && cd /etc/init.d && wget https://github.com/emonbhuiyan/BDIX/raw/main/bdix && chmod +x /etc/init.d/bdix && rm /etc/redsocks.conf && rm /etc/init.d/redsocks
```
[Click here to install with one command run](#one-command-run-installation)

Thanks for following my tutorial. Follow me to get more interesting tips and tricks.
