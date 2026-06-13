# BDIX OpenWRT with LuCI Web UI

BDIX Proxy is a transparent TCP-to-SOCKS redirector setup customized for BDIX bypass on OpenWRT. This project provides a simple script and configuration setup to easily run a redirected BDIX proxy client on an OpenWRT router, complete with a modern **LuCI Web UI** interface (for OpenWrt 21.02+ / 22.03+ / 23.05+).

It is ideal for routing all LAN traffic through a SOCKS5/SOCKS4 proxy server (e.g., for BDIX bypass configurations).

---

## 1. Quick Installation (One-Command Run)

Run the following command in your router's SSH terminal to automatically download, install dependencies, and configure the LuCI Web UI:

```bash
cd /tmp && wget --no-check-certificate https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/dev/install.sh && chmod +x install.sh && sh install.sh && rm install.sh && cd /
```

Once installed, clear your browser cache and refresh your router's web admin page.

---

## 2. Configuration Options

### Option A: Web UI Configuration (Recommended)
1. Log into your router's web interface (LuCI).
2. Navigate to **Services** -> **BDIX Proxy**.
3. Toggle the **Enable BDIX Service** checkbox.
4. Input your **Proxy Server IP/Host**, **Port**, and authentication details (if required).
5. Click **Save & Apply**.
6. **Note:** If you add or modify the **Direct Connection (Bypass) Settings**, you must restart the BDIX service for the bypass rules to take effect.

### Option B: Command Line Configuration (UCI)
Instead of manually editing configuration files, you can configure the service using OpenWrt's native UCI configuration utility:

```bash
# Enable the service
uci set bdix.global.enabled='1'

# Set proxy host and port
uci set bdix.connection.ip='xx.xx.xx.xx'
uci set bdix.connection.port='xxxx'

# Set proxy type (socks5, socks4, http-connect, http-relay)
uci set bdix.connection.type='socks5'

# Set authentication (optional)
uci set bdix.connection.login='username'
uci set bdix.connection.password='password'

# Save and apply changes
uci commit bdix
/etc/init.d/bdix reload
```

---

## 3. Service Commands (SSH Terminal)

* **Start service manually:**
  ```bash
  /etc/init.d/bdix start
  ```
* **Stop service manually:**
  ```bash
  /etc/init.d/bdix stop
  ```
* **Restart service:**
  ```bash
  /etc/init.d/bdix restart
  ```
* **Enable service on boot:**
  ```bash
  /etc/init.d/bdix enable
  ```
* **Disable service on boot:**
  ```bash
  /etc/init.d/bdix disable
  ```

---

## 4. Manual Installation Step-by-Step

If you prefer to configure everything manually:

### Step 1: Update packages and install dependencies
```bash
opkg update
opkg install iptables iptables-mod-nat-extra redsocks
```

### Step 2: Download configuration and script files
Copy the directories from this repository into your router's filesystem:
* **UCI Configuration:** Save [etc/config/bdix](etc/config/bdix) to `/etc/config/bdix`
* **Init Service Script:** Save [etc/init.d/bdix](etc/init.d/bdix) to `/etc/init.d/bdix` and run `chmod +x /etc/init.d/bdix`
* **LuCI Sidebar Entry:** Save [usr/share/luci/menu.d/luci-app-bdix.json](usr/share/luci/menu.d/luci-app-bdix.json) to `/usr/share/luci/menu.d/luci-app-bdix.json`
* **LuCI ACL Rules:** Save [usr/share/rpcd/acl.d/luci-app-bdix.json](usr/share/rpcd/acl.d/luci-app-bdix.json) to `/usr/share/rpcd/acl.d/luci-app-bdix.json`
* **LuCI JavaScript view:** Save [www/luci-static/resources/view/services/bdix.js](www/luci-static/resources/view/services/bdix.js) to `/www/luci-static/resources/view/services/bdix.js`

### Step 3: Refresh LuCI services
```bash
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
```

---

## 5. Uninstallation

To completely remove the LuCI Web UI components, uninstall package dependencies, and restore original configurations, run the following command in your router's SSH terminal:

```bash
cd /tmp && wget --no-check-certificate https://github.com/emonbhuiyan/BDIX-OpenWRT/raw/dev/uninstall.sh && chmod +x uninstall.sh && sh uninstall.sh && rm uninstall.sh && cd /
```

---

## 6. Optional: Leak Prevention (WebRTC & DNS Leaks)

By default, transparent proxies only intercept **TCP** traffic. Because WebRTC STUN queries and standard DNS lookups run over **UDP**, they can bypass the proxy and leak your real WAN IP or ISP's DNS servers. 

If you want to secure these leaks, you can implement these optional, non-intrusive configurations:

### A. Prevent DNS Leaks (DNS-over-HTTPS)
By encrypting DNS requests over HTTPS (TCP port 443), they are automatically captured by BDIX and securely routed through your SOCKS5 proxy:
1. SSH into your router and install the lightweight DoH client:
   ```bash
   opkg update
   opkg install https-dns-proxy
   ```
2. Enable and start the service:
   ```bash
   /etc/init.d/https-dns-proxy enable
   /etc/init.d/https-dns-proxy start
   ```

* **To Disable**: Stop and disable the DoH service:
  ```bash
  /etc/init.d/https-dns-proxy stop
  /etc/init.d/https-dns-proxy disable
  ```
* **To Uninstall**: Completely remove the package:
  ```bash
  opkg remove https-dns-proxy
  ```

### B. Prevent WebRTC Leaks (Block WAN UDP)
Force browsers to fall back to secure TCP connections for WebRTC by blocking outgoing UDP traffic from client devices (except standard DNS on port 53 and NTP time sync on port 123):
1. Navigate to **Network** -> **Firewall** -> **Custom Rules** in LuCI (or edit `/etc/firewall.user`).
2. Add the following rule:
   ```bash
   # Block client UDP traffic to WAN to prevent WebRTC leaks
   iptables -I FORWARD -i br-lan -o wan -p udp --dport ! 53 --dport ! 123 -j REJECT
   ```
   *(Note: This rule will block UDP-based online multiplayer games. Skip this step if you play games that require UDP).*
3. Restart the firewall to apply:
   ```bash
   /etc/init.d/firewall restart
   ```

* **To Disable / Uninstall**: Remove the `iptables` line from your custom rules list and restart the firewall:
  ```bash
  /etc/init.d/firewall restart
  ```
