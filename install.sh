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
printf "${BLUE}${BOLD}           BDIX OpenWRT & LuCI UI Installer           ${NC}\n"
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
/etc/init.d/bdix stop >/dev/null 2>&1 || true

# 4. Backup old configurations if they exist
log_info "Backing up existing configurations..."
[ -f /etc/config/bdix ] && mv /etc/config/bdix /etc/config/bdix.bkp
[ -f /etc/init.d/bdix ] && mv /etc/init.d/bdix /etc/init.d/bdix.bkp

# 5. Download the latest source files as a tarball from GitHub
log_info "Downloading Web UI components from dev branch..."
wget -O /tmp/bdix-ui.tar.gz https://github.com/emonbhuiyan/BDIX-OpenWRT/archive/refs/heads/dev.tar.gz

# 6. Extract the tarball to a temporary directory
mkdir -p /tmp/bdix-ui-extract
tar -zxf /tmp/bdix-ui.tar.gz -C /tmp/bdix-ui-extract

# 7. Copy components to system directories
log_info "Deploying system files..."
cp -r /tmp/bdix-ui-extract/BDIX-OpenWRT-dev/etc/* /etc/
cp -r /tmp/bdix-ui-extract/BDIX-OpenWRT-dev/usr/* /usr/
cp -r /tmp/bdix-ui-extract/BDIX-OpenWRT-dev/www/* /www/

# 8. Set execute permissions for the init script
chmod +x /etc/init.d/bdix

# 9. Clean up temporary files
rm -rf /tmp/bdix-ui.tar.gz /tmp/bdix-ui-extract

# 10. Enable service and reload LuCI
log_info "Registering startup hooks and reloading LuCI services..."
/etc/init.d/bdix enable

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
printf "   Services -> BDIX Proxy\n"
printf "${GREEN}======================================================${NC}\n"
