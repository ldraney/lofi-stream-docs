#!/bin/bash
# check-streams.sh
# Health check script for lofi stream services
# Run on production server to verify streams are healthy

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

# Services to check (add more as you scale)
SERVICES=(
    "lofi-stream"
    "lofi-stream-twitch"
    "lofi-stream-kick"
    "lofi-stream-dlive"
    "lofi-stream-odysee"
)

# Display mapping
declare -A DISPLAYS=(
    [":99"]="YouTube"
    [":98"]="Twitch"
    [":97"]="Kick"
    [":95"]="DLive"
    [":94"]="Odysee"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# FUNCTIONS
# ============================================================================

check_service() {
    local service="$1"

    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "  ${GREEN}[OK]${NC} $service is running"
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $service is NOT running"
        return 1
    fi
}

check_ffmpeg_processes() {
    local count=$(pgrep -c ffmpeg 2>/dev/null || echo "0")

    if [[ "$count" -ge "${#SERVICES[@]}" ]]; then
        echo -e "  ${GREEN}[OK]${NC} $count ffmpeg process(es) running"
        return 0
    elif [[ "$count" -gt 0 ]]; then
        echo -e "  ${YELLOW}[WARN]${NC} Only $count ffmpeg process(es) running (expected ${#SERVICES[@]})"
        return 1
    else
        echo -e "  ${RED}[FAIL]${NC} No ffmpeg processes running"
        return 1
    fi
}

check_display() {
    local display="$1"
    local name="$2"

    if pgrep -f "Xvfb $display" > /dev/null 2>&1; then
        echo -e "  ${GREEN}[OK]${NC} Display $display ($name) is running"
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} Display $display ($name) is NOT running"
        return 1
    fi
}

check_audio_sinks() {
    if command -v pactl &> /dev/null; then
        local sinks=$(pactl list sinks short 2>/dev/null | wc -l)
        if [[ "$sinks" -ge "${#SERVICES[@]}" ]]; then
            echo -e "  ${GREEN}[OK]${NC} $sinks PulseAudio sink(s) configured"
            return 0
        else
            echo -e "  ${YELLOW}[WARN]${NC} Only $sinks audio sink(s) found"
            return 1
        fi
    else
        echo -e "  ${YELLOW}[SKIP]${NC} pactl not available"
        return 0
    fi
}

get_uptime() {
    local service="$1"
    local uptime=$(systemctl show "$service" --property=ActiveEnterTimestamp 2>/dev/null | cut -d= -f2)
    if [[ -n "$uptime" && "$uptime" != "" ]]; then
        echo "    Started: $uptime"
    fi
}

show_resource_usage() {
    echo ""
    echo "Resource Usage:"

    # CPU
    local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d% -f1)
    echo "  CPU: ${cpu}%"

    # Memory
    local mem=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')
    echo "  Memory: $mem"

    # FFmpeg processes detail
    echo ""
    echo "FFmpeg Processes:"
    ps aux | grep '[f]fmpeg' | awk '{printf "  PID %s: CPU %.1f%%, MEM %.1f%%\n", $2, $3, $4}' || echo "  None running"
}

# ============================================================================
# MAIN
# ============================================================================

echo "=========================================="
echo "LOFI STREAM HEALTH CHECK"
echo "$(date)"
echo "=========================================="
echo ""

FAILURES=0

# Check systemd services
echo "Services:"
for service in "${SERVICES[@]}"; do
    if ! check_service "$service"; then
        ((FAILURES++))
    else
        get_uptime "$service"
    fi
done

echo ""

# Check processes
echo "Processes:"
check_ffmpeg_processes || ((FAILURES++))
for display in "${!DISPLAYS[@]}"; do
    check_display "$display" "${DISPLAYS[$display]}" || ((FAILURES++))
done
check_audio_sinks || true  # Don't count as failure

# Show resource usage
show_resource_usage

echo ""
echo "=========================================="

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}$FAILURES check(s) failed${NC}"
    exit 1
fi
