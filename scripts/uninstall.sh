#!/usr/bin/env bash

set -euo pipefail

THEME_NAME="caelestia"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"
TEMPLATE_FILE="$HOME/.config/caelestia/templates/sddm-theme.conf"
TEMPLATE_DIR="$HOME/.config/caelestia/templates"
SERVICE_NAME="caelestia-sync.service"

echo "Uninstalling Caelestia SDDM Theme..."

# 1. Stop and disable the systemd service
echo "Stopping and disabling $SERVICE_NAME..."
if systemctl is-active --quiet "$SERVICE_NAME"; then
    sudo systemctl stop "$SERVICE_NAME"
    echo "✓ Stopped service."
else
    echo "Service not running, skipped."
fi

if systemctl is-enabled --quiet "$SERVICE_NAME"; then
    sudo systemctl disable "$SERVICE_NAME"
    echo "✓ Disabled service."
else
    echo "Service not enabled, skipped."
fi

# 2. Remove the service file
echo "Removing service file from /etc/systemd/system/..."
if [[ -f "/etc/systemd/system/$SERVICE_NAME" ]]; then
    sudo rm -f "/etc/systemd/system/$SERVICE_NAME"
    sudo systemctl daemon-reload
    echo "✓ Removed service file."
else
    echo "Service file not found, skipped."
fi

# 3. Remove the SDDM theme directory
echo "Removing SDDM theme from $THEME_DIR..."
if [[ -d "$THEME_DIR" ]]; then
    sudo rm -rf "$THEME_DIR"
    echo "✓ Removed theme directory."
else
    echo "Theme directory not found, skipped."
fi

# 4. Remove SDDM theme configuration
echo "Removing SDDM theme configuration..."
echo "Note: /etc/sddm.conf is left untouched - you may want to manually update Current= setting."
if [[ -f "/etc/sddm.conf.d/caelestia.conf" ]]; then
    sudo rm -f "/etc/sddm.conf.d/caelestia.conf"
    echo "✓ Removed /etc/sddm.conf.d/caelestia.conf."

    # Remove the directory if it's empty
    if [[ -d "/etc/sddm.conf.d" ]] && [[ -z "$(sudo ls -A /etc/sddm.conf.d)" ]]; then
        sudo rmdir "/etc/sddm.conf.d"
        echo "✓ Removed empty /etc/sddm.conf.d directory."
    fi
else
    echo "SDDM config drop-in not found, skipped."
fi

# 5. Remove the template configuration
echo "Removing template file from $TEMPLATE_FILE..."
if [[ -f "$TEMPLATE_FILE" ]]; then
    rm -f "$TEMPLATE_FILE"
    echo "✓ Removed template file."
else
    echo "Template file not found, skipped."
fi

if [[ -d "$TEMPLATE_DIR" ]] && [[ -z "$(ls -A "$TEMPLATE_DIR")" ]]; then
    rmdir "$TEMPLATE_DIR"
    echo "✓ Removed empty template directory."
fi

echo "✅ Uninstall complete."
