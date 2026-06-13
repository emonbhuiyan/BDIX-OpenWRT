#!/bin/sh

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helper logging functions
log_info() {
	printf "${BLUE}${BOLD}ℹ [INFO]${NC} %s\n" "$1"
}

log_success() {
	printf "${GREEN}${BOLD}✔ [SUCCESS]${NC} %s\n" "$1"
}

log_warn() {
	printf "${YELLOW}${BOLD}⚠ [WARN]${NC} %s\n" "$1"
}

# Display Header Banner
printf "${YELLOW}======================================================${NC}\n"
printf "${YELLOW}${BOLD}        Redsocks OpenWRT Web UI Uninstaller          ${NC}\n"
printf "${YELLOW}======================================================${NC}\n"
printf "\n"

# 1. Stop and disable the service
log_info "Stopping and disabling redsocks service..."
/etc/init.d/redsocks stop >/dev/null 2>&1 || true
/etc/init.d/redsocks disable >/dev/null 2>&1 || true

# 2. Restore backed up configuration if it exists
log_info "Restoring original configuration backups..."
if [ -f /etc/redsocks.conf.bkp ]; then
	mv /etc/redsocks.conf.bkp /etc/redsocks.conf
	log_success "Restored original /etc/redsocks.conf"
else
	rm -f /etc/redsocks.conf
fi

if [ -f /etc/config/redsocks.bkp ]; then
	mv /etc/config/redsocks.bkp /etc/config/redsocks
	log_success "Restored original /etc/config/redsocks"
else
	rm -f /etc/config/redsocks
fi

if [ -f /etc/init.d/redsocks.bkp ]; then
	mv /etc/init.d/redsocks.bkp /etc/init.d/redsocks
	log_success "Restored original service init script"
else
	rm -f /etc/init.d/redsocks
fi

# 3. Remove installed files
log_info "Removing Redsocks-OpenWRT UI components..."
rm -f /usr/share/luci/menu.d/luci-app-redsocks.json
rm -f /usr/share/rpcd/acl.d/luci-app-redsocks.json
rm -rf /www/luci-static/resources/view/services/redsocks.js

# 4. Remove packages if not in use by other services
log_info "Checking package dependencies for cleanup..."
# opkg automatically refuses to remove a package if another package depends on it
opkg remove redsocks || log_warn "Redsocks package skipped (other packages depend on it)."
opkg remove iptables-mod-nat-extra || log_warn "iptables-mod-nat-extra skipped (other packages depend on it)."

# 5. Clear LuCI cache and restart web/rpc services
log_info "Clearing cache and restarting web/RPC services..."
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/rpcd restart || true
/etc/init.d/uhttpd restart || true

printf "\n"
printf "${YELLOW}======================================================${NC}\n"
log_success "Uninstallation completed successfully!"
printf "${YELLOW}======================================================${NC}\n"
