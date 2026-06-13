#!/bin/sh

# Exit on error
set -e

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
printf "${BLUE}======================================================${NC}\n"
printf "${BLUE}${BOLD}         Redsocks OpenWRT & LuCI UI Installer         ${NC}\n"
printf "${BLUE}======================================================${NC}\n"
printf "\n"

# 1. Update package manager
log_info "Updating package database..."
opkg update

# 2. Install dependencies
log_info "Installing core package dependencies..."
opkg install iptables iptables-mod-nat-extra redsocks

# 3. Stop running services if any
log_info "Cleaning up old service instances..."
service redsocks stop >/dev/null 2>&1 || true

# 4. Backup old configurations if they exist
log_info "Backing up existing configurations..."
if [ -f /etc/redsocks.conf ]; then
	mv /etc/redsocks.conf /etc/redsocks.conf.bkp
	log_warn "Existing /etc/redsocks.conf backed up to redsocks.conf.bkp"
fi
[ -f /etc/config/redsocks ] && mv /etc/config/redsocks /etc/config/redsocks.bkp
[ -f /etc/init.d/redsocks ] && mv /etc/init.d/redsocks /etc/init.d/redsocks.bkp

# 5. Download the latest source files as a tarball from GitHub
log_info "Downloading Web UI components from dev branch..."
wget -O /tmp/redsocks-ui.tar.gz https://github.com/emonbhuiyan/Redsocks-OpenWRT/archive/refs/heads/dev.tar.gz

# 6. Extract the tarball to a temporary directory
mkdir -p /tmp/redsocks-ui-extract
tar -zxf /tmp/redsocks-ui.tar.gz -C /tmp/redsocks-ui-extract

# 7. Copy components to system directories
log_info "Deploying system files..."
cp -r /tmp/redsocks-ui-extract/Redsocks-OpenWRT-dev/etc/* /etc/
cp -r /tmp/redsocks-ui-extract/Redsocks-OpenWRT-dev/usr/* /usr/
cp -r /tmp/redsocks-ui-extract/Redsocks-OpenWRT-dev/www/* /www/

# 8. Set execute permissions for the init script
chmod +x /etc/init.d/redsocks

# 9. Clean up temporary files
rm -rf /tmp/redsocks-ui.tar.gz /tmp/redsocks-ui-extract

# 10. Enable service and reload LuCI
log_info "Registering startup hooks and reloading LuCI services..."
/etc/init.d/redsocks enable

# Clear LuCI cache
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache

# Restart uhttpd and rpcd
/etc/init.d/rpcd restart || true
/etc/init.d/uhttpd restart || true

printf "\n"
printf "${GREEN}======================================================${NC}\n"
log_success "Installation completed successfully!"
printf "${GREEN}------------------------------------------------------${NC}\n"
printf " Navigate to your router's Web Interface (LuCI):\n"
printf "   Services -> Redsocks Proxy\n"
printf "${GREEN}======================================================${NC}\n"
