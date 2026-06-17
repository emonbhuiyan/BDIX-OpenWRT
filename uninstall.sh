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

pkg_remove() {
	if command -v opkg >/dev/null 2>&1; then
		opkg remove "$1"
	elif command -v apk >/dev/null 2>&1; then
		apk del "$1"
	else
		log_warn "Neither opkg nor apk package manager was found!"
		return 1
	fi
}

# Display Header Banner
printf "${YELLOW}======================================================${NC}\n"
printf "${YELLOW}${BOLD}         BDIX OpenWRT Web UI Uninstaller             ${NC}\n"
printf "${YELLOW}======================================================${NC}\n"
printf "\n"

# 1. Stop and disable the service
log_info "Stopping and disabling bdix service..."
/etc/init.d/bdix stop >/dev/null 2>&1 || true
/etc/init.d/bdix disable >/dev/null 2>&1 || true

# 2. Restore backed up configuration if it exists
log_info "Restoring original configuration backups..."
if [ -f /etc/config/bdix.bkp ]; then
	mv /etc/config/bdix.bkp /etc/config/bdix
	log_success "Restored original /etc/config/bdix"
else
	rm -f /etc/config/bdix
fi

if [ -f /etc/init.d/bdix.bkp ]; then
	mv /etc/init.d/bdix.bkp /etc/init.d/bdix
	log_success "Restored original service init script"
else
	rm -f /etc/init.d/bdix
fi

# 3. Remove installed files
log_info "Removing BDIX-OpenWRT UI components..."
rm -f /usr/share/luci/menu.d/luci-app-bdix.json
rm -f /usr/share/rpcd/acl.d/luci-app-bdix.json
rm -rf /www/luci-static/resources/view/services/bdix.js

# 4. Remove packages if not in use by other services
log_info "Checking package dependencies for cleanup..."
# Package manager automatically refuses to remove a package if another package depends on it
pkg_remove redsocks || log_warn "Redsocks package skipped (other packages depend on it)."
pkg_remove iptables-mod-nat-extra || log_warn "iptables-mod-nat-extra skipped (other packages depend on it)."

# 5. Clear LuCI cache and restart web/rpc services
log_info "Clearing cache and restarting web/RPC services..."
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/rpcd restart || true
/etc/init.d/uhttpd restart || true

printf "\n"
printf "${YELLOW}======================================================${NC}\n"
log_success "Uninstallation completed successfully!"
printf "${YELLOW}======================================================${NC}\n"
