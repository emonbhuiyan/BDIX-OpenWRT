# BDIX Bypass Service on OpenWRT Router
BDIX bypass become very popular in Bangladesh, especially in rural and urban areas. Socks5 is one of the popular proxy protocols here. Could we use the Socks5 proxy on our router? Yeah, we can use the Socks5 proxy on the OpenWRT router with Redsocks. I customized Redsocks as BDIX, especially for BDIX proxy users. However, I found a very rare tutorial about configuring a Socks5 proxy on an OpenWRT router. With this tutorial, we can use it on our OpenWRT router easily. To install and configure the Socks5 proxy, please make sure you have installed OpenWrt on your router. Then run commands as follows:

# Video tutorial
Installation process described in this video tutorial:

<a href="https://www.youtube.com/watch?v=jDpXC51o984">
  <img src="https://i.ytimg.com/vi/jDpXC51o984/maxresdefault.jpg" alt="Install BDIX bypass on OpenWRT router" width="500"/>
</a>

# BDIX proxy service installation:
Run the following command to install the BDIX proxy extension automatically:
```
cd /tmp && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/install.sh && chmod +x install.sh && clear && sh install.sh && rm install.sh
```
Just run it and wait for completion. And enjoy.

## To update proxy IP, Port, Username & Password
```
vi /etc/bdix.conf
```
After the update press `esc` key then `:wq` to save or `:q!` to discard changes

<img src="https://i.imgur.com/8uLp8I9.png" alt="Update proxy IP, Port, Username & Password" width="500"/>

# How to start and stop BDIX:

### To start the BDIX proxy bypass
```
service bdix start
```

### To stop BDIX proxy bypass
```
service bdix stop
```

### To restart the BDIX proxy bypass
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

# To update direct connection list:

```
vi /etc/init.d/bdix
```
You can delete the existing domain line from the list or add a new line and replace the domain name to add your desired direction connection.

After the update press `esc` key then `:wq` to save or `:q!` to discard changes

# To uninstall this module from your OpenWRT:
Just run the following commands to uninstall this program from your OpenWRT router.

```
service bdix stop
```

```
service bdix disable
```

```
rm /etc/init.d/bdix
```

```
rm /etc/bdix.conf
```

Please reboot your router after the uninstallation process.

Thanks for following my tutorial. Follow me to get more interesting tips and tricks.
