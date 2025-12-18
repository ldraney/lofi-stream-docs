#!/bin/bash
# setup-dev-user.sh
# Run this once on the dev server to create the lofidev user

set -e

DEV_USER="lofidev"
DEV_HOME="/home/$DEV_USER"

echo "Creating dev user: $DEV_USER"

# Create user with home directory
useradd -m -s /bin/bash "$DEV_USER" || echo "User already exists"

# Add to required groups for streaming
usermod -aG audio,video "$DEV_USER"

# Set up SSH access (copy root's authorized_keys)
mkdir -p "$DEV_HOME/.ssh"
cp /root/.ssh/authorized_keys "$DEV_HOME/.ssh/" 2>/dev/null || echo "No root authorized_keys found"
chown -R "$DEV_USER:$DEV_USER" "$DEV_HOME/.ssh"
chmod 700 "$DEV_HOME/.ssh"
chmod 600 "$DEV_HOME/.ssh/authorized_keys" 2>/dev/null || true

# Create directory for stream projects
mkdir -p "$DEV_HOME/streams"
chown "$DEV_USER:$DEV_USER" "$DEV_HOME/streams"

# Set up PulseAudio for the user
mkdir -p /run/user/$(id -u $DEV_USER)
chown "$DEV_USER:$DEV_USER" /run/user/$(id -u $DEV_USER)

echo "Done! Dev user created: $DEV_USER"
echo "Home directory: $DEV_HOME"
echo ""
echo "SSH access: ssh lofidev@5.78.42.22"
echo ""
echo "Next: Install reset-dev.sh to /opt/scripts/ and set up cron"
