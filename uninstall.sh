#!/bin/sh

# Exit on error
set -e

echo "Starting Redsocks & LuCI Web UI Uninstallation..."

# 1. Stop and disable the service
echo "Stopping and disabling redsocks service..."
/etc/init.d/redsocks stop || true
/etc/init.d/redsocks disable || true

# 2. Restore backed up configuration if it exists
echo "Restoring original configuration backups if available..."
if [ -f /etc/redsocks.conf.bkp ]; then
	mv /etc/redsocks.conf.bkp /etc/redsocks.conf
else
	rm -f /etc/redsocks.conf
fi

if [ -f /etc/config/redsocks.bkp ]; then
	mv /etc/config/redsocks.bkp /etc/config/redsocks
else
	rm -f /etc/config/redsocks
fi

if [ -f /etc/init.d/redsocks.bkp ]; then
	mv /etc/init.d/redsocks.bkp /etc/init.d/redsocks
else
	rm -f /etc/init.d/redsocks
fi

# 3. Remove installed files
echo "Removing Redsocks-OpenWRT UI components..."
rm -f /usr/share/luci/menu.d/luci-app-redsocks.json
rm -f /usr/share/rpcd/acl.d/luci-app-redsocks.json
rm -rf /www/luci-static/resources/view/services/redsocks.js

# 4. Clear LuCI cache and restart web/rpc services
echo "Clearing cache and restarting web/RPC services..."
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/rpcd restart || true
/etc/init.d/uhttpd restart || true

echo "=================================================================="
echo "Uninstallation complete!"
echo "If you wish to completely remove redsocks package and firewall rules, run:"
echo "opkg remove redsocks iptables-mod-nat-extra"
echo "=================================================================="
