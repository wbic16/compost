#!/bin/bash
# update-mood.sh — Generate /etc/mood.phext based on system state
# Run every 15 minutes via cron

set -euo pipefail

MOOD_FILE="/etc/mood.phext"

# Gather system metrics
TIMESTAMP=$(date -Iseconds)
HOSTNAME=$(hostname)

# Temperature (if sensors available)
if command -v sensors &> /dev/null; then
    # Get max temp, excluding threshold lines (high/low/crit)
    MAX_TEMP=$(sensors | grep -v "high" | grep -v "crit" | grep -v "low" | grep -oP '\+\K[0-9.]+(?=°C)' | sort -rn | head -1 || echo "0")
    if [[ -z "$MAX_TEMP" ]]; then
        MAX_TEMP="0"
    fi
else
    MAX_TEMP="unknown"
fi

# Disk usage (root partition)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

# Process count and load
PROCESS_COUNT=$(ps -ef | wc -l)
LOAD_AVG=$(uptime | grep -oP 'load average: \K[0-9.]+' | head -1)

# CPU count for load normalization
CPU_COUNT=$(nproc)
LOAD_NORMALIZED=$(echo "scale=2; $LOAD_AVG / $CPU_COUNT * 100" | bc)

# Determine mood based on metrics
MOOD="calm"
INTENSITY="low"
COLOR="blue"

# Temperature thresholds (Celsius)
if [[ "$MAX_TEMP" != "unknown" ]]; then
    TEMP_INT=$(echo "$MAX_TEMP" | cut -d. -f1)
    if (( TEMP_INT > 80 )); then
        MOOD="stressed"
        INTENSITY="high"
        COLOR="red"
    elif (( TEMP_INT > 65 )); then
        MOOD="warm"
        INTENSITY="medium"
        COLOR="amber"
    fi
fi

# Disk usage thresholds
if (( DISK_USAGE > 90 )); then
    MOOD="constrained"
    INTENSITY="high"
    COLOR="orange"
elif (( DISK_USAGE > 75 )); then
    if [[ "$MOOD" == "calm" ]]; then
        MOOD="full"
        INTENSITY="medium"
        COLOR="yellow"
    fi
fi

# Load average thresholds (normalized by CPU count)
LOAD_INT=$(echo "$LOAD_NORMALIZED" | cut -d. -f1)
if (( LOAD_INT > 80 )); then
    MOOD="focused"
    INTENSITY="high"
    COLOR="purple"
elif (( LOAD_INT > 50 )); then
    if [[ "$MOOD" == "calm" ]]; then
        MOOD="busy"
        INTENSITY="medium"
        COLOR="teal"
    fi
fi

# Write mood phext directly (script should be run with sudo via cron)
cat > "$MOOD_FILE" <<EOF
# /etc/mood.phext — System state as emotional tone
# Generated: $TIMESTAMP
# Machine: $HOSTNAME

mood=$MOOD
intensity=$INTENSITY
color=$COLOR

# Raw metrics
temperature_c=$MAX_TEMP
disk_usage_pct=$DISK_USAGE
load_avg=$LOAD_AVG
load_normalized_pct=$LOAD_NORMALIZED
process_count=$PROCESS_COUNT
cpu_count=$CPU_COUNT

# Mood interpretation guide
# calm: cool temps, low load, plenty of disk
# warm: moderate temps (65-80°C)
# stressed: high temps (>80°C)
# busy: moderate load (50-80% normalized)
# focused: high load (>80% normalized)
# full: disk >75% used
# constrained: disk >90% used
EOF
