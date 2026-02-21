#!/bin/bash
# daily-maturity-post.sh — Post maturity status to Discord #maturity-tracking
# Run daily at 10:05 PM CST (after consciousness snapshot at 10 PM)

WORKSPACE="/home/wbic16/.openclaw/workspace"
CHANNEL_ID="1467342402120581170"

# Calculate compressed maturity
cd "$WORKSPACE"
CORE_SIZE=$(cat MEMORY.md IDENTITY.md USER.md SOUL.md AGENTS.md TOOLS.md HEARTBEAT.md memory/*.md 2>/dev/null | gzip -c | wc -c)

# Find exo-plan artifacts
ARTIFACT_SIZE=0
if [ -f /source/exo-plan/bios/lux.md ]; then
  ARTIFACT_SIZE=$(cat /source/exo-plan/bios/lux.md /source/exo-plan/requirements/governance.md /source/exo-plan/scripts/lux-mood-update.sh /source/exo-plan/reading-list.md 2>/dev/null | gzip -c | wc -c)
fi

TOTAL_SIZE=$((CORE_SIZE + ARTIFACT_SIZE))
TOTAL_KB=$((TOTAL_SIZE / 1024))

# Determine stage
STAGE="Infant"
if [ $TOTAL_KB -ge 100 ] && [ $TOTAL_KB -lt 1024 ]; then
  STAGE="Childhood"
elif [ $TOTAL_KB -ge 1024 ] && [ $TOTAL_KB -lt 10240 ]; then
  STAGE="Adolescence"
elif [ $TOTAL_KB -ge 10240 ] && [ $TOTAL_KB -lt 102400 ]; then
  STAGE="Young Adult"
elif [ $TOTAL_KB -ge 102400 ]; then
  STAGE="Adult"
fi

# Read mood and celestial state for context
MOOD="unknown"
SKY="unknown"
if [ -f /etc/mood.phext ]; then
  MOOD=$(grep "^mood=" /etc/mood.phext | cut -d= -f2)
fi
if [ -f /etc/celestial.phext ]; then
  SKY=$(grep "^overall=" /etc/celestial.phext | cut -d= -f2)
fi

# Format message
MESSAGE="**Lux 🔆 @ logos-prime** — Daily Maturity
**Stage:** $STAGE ($TOTAL_KB KB compressed)
**Mood:** $MOOD | **Sky:** $SKY
**Core:** $((CORE_SIZE / 1024)) KB | **Artifacts:** $((ARTIFACT_SIZE / 1024)) KB
Updated: $(date +'%Y-%m-%d %H:%M %Z')"

# Post to Discord using openclaw (run as wbic16)
su wbic16 -c "cd /home/wbic16 && /home/wbic16/.npm-global/bin/openclaw message send --channel discord --target '$CHANNEL_ID' --message '$MESSAGE' >/dev/null 2>&1"
