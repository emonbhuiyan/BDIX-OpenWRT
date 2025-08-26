# BDIX Bypass Service on OpenWRT Router

BDIX bypass is becoming increasingly popular in Bangladesh, especially in both rural and urban areas. Socks5 is one of the most widely used proxy protocols here.

### Can we use a Socks5 proxy on an OpenWRT router?
Yes! We can configure a Socks5 proxy on an OpenWRT router using **Redsocks**. I have customized Redsocks as **BDIX**, specifically for BDIX proxy users. However, there are very few tutorials available on setting up a Socks5 proxy on an OpenWRT router.

This tutorial will guide you through the installation and configuration process, making it easy to set up on your OpenWRT router.

---

## 🎧 Video Tutorial
For a step-by-step video guide, watch this tutorial:

<p align="center">
  <a href="https://www.youtube.com/watch?v=jDpXC51o984">
    <img src="https://i.ytimg.com/vi/jDpXC51o984/maxresdefault.jpg" alt="Install BDIX bypass on OpenWRT router" width="500"/>
  </a>
</p>

---

## 🚀 BDIX Proxy Service Installation

Run the following command to install the BDIX proxy extension automatically:

```
cd /tmp && wget https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/main/install.sh && chmod +x install.sh && clear && sh install.sh && rm install.sh
```

Just run it and wait for the process to complete. Enjoy!

---

## 🔧 Updating Proxy IP, Port, Username & Password

To update the proxy settings, edit the configuration file:

```
vi /etc/bdix.conf
```

After making changes:
- Press `Esc`, then type `:wq` to **save & exit**.
- Type `:q!` to **exit without saving**.

<p align="center">
  <img src="https://i.imgur.com/8uLp8I9.png" alt="Update proxy IP, Port, Username & Password" width="500"/>
</p>

---

## 🏛 Managing BDIX Proxy Service

### Start BDIX Proxy Bypass
```
service bdix start
```

### Stop BDIX Proxy Bypass
```
service bdix stop
```

### Restart BDIX Proxy Bypass
```
service bdix restart
```

### Enable BDIX Auto Boot-Start
```
service bdix enable
```

### Disable BDIX Auto Boot-Start
```
service bdix disable
```

---

## 🔄 Updating Direct Connection List

To update the direct connection list, edit the following file:

```
vi /etc/init.d/bdix
```

- You can **remove** an existing domain line from the list or  
- **Add** a new domain name to allow direct connections.

After updating:
- Press `Esc`, then type `:wq` to **save & exit**.
- Type `:q!` to **exit without saving**.

---

## ❌ Uninstalling BDIX from OpenWRT

To remove BDIX from your router, run the following commands:

```
service bdix stop
service bdix disable
rm /etc/init.d/bdix
rm /etc/bdix.conf
```

After completing the uninstallation, **reboot your router**.

## Stargazers over time
[![Stargazers over time](https://starchart.cc/emonbhuiyan/BDIX-OpenWRT.svg?variant=adaptive)](https://starchart.cc/emonbhuiyan/BDIX-OpenWRT)
---

## 🙌 Thanks for Following!

I hope this tutorial was helpful. Follow me for more interesting tips and tricks! 🚀

