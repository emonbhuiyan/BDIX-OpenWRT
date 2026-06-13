#!/bin/sh

# Exit on error
set -e

echo "Starting Redsocks & LuCI Web UI Installation..."

# 1. Update package manager
echo "Updating packages..."
opkg update

# 2. Install dependencies
echo "Installing required packages (iptables, redsocks, etc.)..."
opkg install iptables iptables-mod-nat-extra redsocks

# 3. Stop running services if any
echo "Stopping existing redsocks service..."
service redsocks stop || true

# 4. Backup old configurations if they exist
[ -f /etc/redsocks.conf ] && mv /etc/redsocks.conf /etc/redsocks.conf.bkp
[ -f /etc/config/redsocks ] && mv /etc/config/redsocks /etc/config/redsocks.bkp
[ -f /etc/init.d/redsocks ] && mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp

# 5. Download the latest source files as a tarball from GitHub
echo "Downloading and installing Redsocks-OpenWRT UI components..."
wget -O /tmp/redsocks-ui.tar.gz https://github.com/emonbhuiyan/Redsocks-OpenWRT/archive/refs/heads/dev.tar.gz

# 6. Extract the tarball to a temporary directory
mkdir -p /tmp/redsocks-ui-extract
tar -zxf /tmp/redsocks-ui.tar.gz -C /tmp/redsocks-ui-extract

# 7. Copy components to system directories
echo "Installing files to system..."
cp -r /tmp/redsocks-ui-extract/Redsocks-OpenWRT-dev/etc/* /etc/
cp -r /tmp/redsocks-ui-extract/Redsocks-OpenWRT-dev/usr/* /usr/
cp -r /tmp/redsocks-ui-extract/Redsocks-OpenWRT-dev/www/* /www/

# 8. Set execute permissions for the init script
chmod +x /etc/init.d/redsocks

# 9. Clean up temporary files
rm -rf /tmp/redsocks-ui.tar.gz /tmp/redsocks-ui-extract

# 10. Enable service and reload LuCI
echo "Enabling Redsocks auto-boot and reloading configurations..."
/etc/init.d/redsocks enable

# Clear LuCI cache to ensure the new menu item and JS render immediately
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache

# Restart uhttpd (LuCI server) to reload permissions and views
/etc/init.d/uhttpd restart || true

echo "=================================================================="
echo "Installation complete!"
echo "You can now log into your router's LuCI Web interface,"
echo "navigate to 'Services' -> 'Redsocks Proxy' and configure your proxy."
echo "=================================================================="
