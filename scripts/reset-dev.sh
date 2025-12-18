#!/bin/bash
# reset-dev.sh
# Daily reset script for the dev server
# Kills dev user processes and cleans their home directory

set -e

DEV_USER="lofidev"
DEV_HOME="/home/$DEV_USER"

# ============================================================================
# ALLOWED PROCESSES (whitelist)
# These process names will NOT be killed during reset
# ============================================================================
ALLOWED_PROCESSES=(
    "sshd"      # SSH sessions
    "bash"      # Active shells (gets killed anyway when sshd child dies, but be explicit)
    "systemd"   # User systemd instance
)

# ============================================================================
# FUNCTIONS
# ============================================================================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

is_allowed() {
    local proc_name="$1"
    for allowed in "${ALLOWED_PROCESSES[@]}"; do
        if [[ "$proc_name" == *"$allowed"* ]]; then
            return 0
        fi
    done
    return 1
}

kill_user_processes() {
    log "Killing processes for user: $DEV_USER"

    # Get all PIDs for the user
    local pids=$(pgrep -u "$DEV_USER" 2>/dev/null || true)

    if [[ -z "$pids" ]]; then
        log "No processes found for $DEV_USER"
        return 0
    fi

    for pid in $pids; do
        local proc_name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "unknown")

        if is_allowed "$proc_name"; then
            log "  Skipping allowed process: $proc_name (PID $pid)"
        else
            log "  Killing: $proc_name (PID $pid)"
            kill -TERM "$pid" 2>/dev/null || true
        fi
    done

    # Give processes time to exit gracefully
    sleep 2

    # Force kill any remaining (except allowed)
    pids=$(pgrep -u "$DEV_USER" 2>/dev/null || true)
    for pid in $pids; do
        local proc_name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "unknown")
        if ! is_allowed "$proc_name"; then
            log "  Force killing: $proc_name (PID $pid)"
            kill -9 "$pid" 2>/dev/null || true
        fi
    done
}

clean_home_directory() {
    log "Cleaning home directory: $DEV_HOME"

    # Preserve .ssh for access, .bashrc/.profile for sanity
    local preserve=(
        ".ssh"
        ".bashrc"
        ".profile"
        ".bash_logout"
    )

    # Move preserved items to temp
    local tmp_dir=$(mktemp -d)
    for item in "${preserve[@]}"; do
        if [[ -e "$DEV_HOME/$item" ]]; then
            cp -a "$DEV_HOME/$item" "$tmp_dir/" 2>/dev/null || true
        fi
    done

    # Nuke everything in home
    rm -rf "$DEV_HOME"/* "$DEV_HOME"/.[!.]* "$DEV_HOME"/..?* 2>/dev/null || true

    # Restore preserved items
    for item in "${preserve[@]}"; do
        if [[ -e "$tmp_dir/$item" ]]; then
            cp -a "$tmp_dir/$item" "$DEV_HOME/" 2>/dev/null || true
        fi
    done
    rm -rf "$tmp_dir"

    # Recreate streams directory
    mkdir -p "$DEV_HOME/streams"
    chown -R "$DEV_USER:$DEV_USER" "$DEV_HOME"

    log "Home directory cleaned"
}

clean_tmp_files() {
    log "Cleaning tmp files"

    # Clean chromium user data dirs
    rm -rf /tmp/chromium-* 2>/dev/null || true

    # Clean any other dev-related tmp files
    rm -rf /tmp/lofi-* 2>/dev/null || true
    rm -rf /tmp/pulse-* 2>/dev/null || true

    log "Tmp files cleaned"
}

stop_user_services() {
    log "Stopping any user systemd services"

    # If the user has any lingering systemd services
    systemctl --user -M "$DEV_USER@" stop '*' 2>/dev/null || true

    log "User services stopped"
}

# ============================================================================
# MAIN
# ============================================================================

log "=========================================="
log "DEV SERVER DAILY RESET"
log "=========================================="

# Safety check - don't run on production!
HOSTNAME=$(hostname)
if [[ "$HOSTNAME" == *"prod"* ]] || [[ "$(hostname -I)" == *"135.181.150.82"* ]]; then
    log "ERROR: This looks like production! Aborting."
    exit 1
fi

# Check if user exists
if ! id "$DEV_USER" &>/dev/null; then
    log "ERROR: User $DEV_USER does not exist. Run setup-dev-user.sh first."
    exit 1
fi

stop_user_services
kill_user_processes
clean_home_directory
clean_tmp_files

log "=========================================="
log "RESET COMPLETE"
log "=========================================="
log ""
log "Dev server is clean and ready for use."
log "SSH: ssh $DEV_USER@$(hostname -I | awk '{print $1}')"
