#!/bin/bash
# install-dev-reset.sh
# Run this on the dev server to install the reset script and cron job

set -e

SCRIPT_DIR="/opt/scripts"
RESET_SCRIPT="reset-dev.sh"

echo "Installing dev reset system..."

# Create scripts directory
mkdir -p "$SCRIPT_DIR"

# Copy reset script (assumes you've scp'd it to /tmp first)
if [[ -f "/tmp/$RESET_SCRIPT" ]]; then
    cp "/tmp/$RESET_SCRIPT" "$SCRIPT_DIR/"
elif [[ -f "./$RESET_SCRIPT" ]]; then
    cp "./$RESET_SCRIPT" "$SCRIPT_DIR/"
else
    echo "ERROR: $RESET_SCRIPT not found in /tmp or current directory"
    echo "SCP it first: scp reset-dev.sh root@5.78.42.22:/tmp/"
    exit 1
fi

chmod +x "$SCRIPT_DIR/$RESET_SCRIPT"

# Install cron job - runs at 4 AM UTC daily
CRON_FILE="/etc/cron.d/dev-reset"
cat > "$CRON_FILE" << 'EOF'
# Daily dev server reset at 4 AM UTC
# Kills dev user processes and cleans home directory
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

0 4 * * * root /opt/scripts/reset-dev.sh >> /var/log/dev-reset.log 2>&1
EOF

chmod 644 "$CRON_FILE"

echo ""
echo "Installed!"
echo "  Script: $SCRIPT_DIR/$RESET_SCRIPT"
echo "  Cron:   $CRON_FILE (runs at 4 AM UTC daily)"
echo "  Log:    /var/log/dev-reset.log"
echo ""
echo "To test manually: $SCRIPT_DIR/$RESET_SCRIPT"
echo "To change time: edit $CRON_FILE"
