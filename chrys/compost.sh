#!/bin/bash
# Chrys 🦋 Daily Compost — Archive session debris
# Runs daily at 6 AM CST via cron

set -e
DATE=$(date +%Y-%m-%d)
REPO=/source/compost
DOMAIN=chrys
LOG="$REPO/$DOMAIN/compost-$DATE.log"

cd "$REPO"
git pull --rebase origin main >> "$LOG" 2>&1

# Archive old media (>3 days)
MEDIA_DIR="$DOMAIN/media/$DATE"
mkdir -p "$MEDIA_DIR"
MEDIA_COUNT=$(find ~/.openclaw/media/inbound/ -type f -mtime +3 2>/dev/null | wc -l)
find ~/.openclaw/media/inbound/ -type f -mtime +3 -exec mv {} "$MEDIA_DIR/" \; 2>/dev/null

# Archive tmp scratch
TMP_DIR="$DOMAIN/tmp/$DATE"
mkdir -p "$TMP_DIR"
TMP_COUNT=0
for f in /tmp/*.md /tmp/*.sh /tmp/*.json /tmp/*.conf; do
  if [ -f "$f" ]; then
    mv "$f" "$TMP_DIR/" 2>/dev/null && TMP_COUNT=$((TMP_COUNT + 1))
  fi
done

echo "[$DATE] media=$MEDIA_COUNT tmp=$TMP_COUNT" >> "$LOG"

# Only commit if there's something to compost
if [ "$MEDIA_COUNT" -gt 0 ] || [ "$TMP_COUNT" -gt 0 ]; then
  git add -A
  git commit -m "compost: chrys $DATE — $MEDIA_COUNT media + $TMP_COUNT tmp" >> "$LOG" 2>&1
  git push origin main >> "$LOG" 2>&1 || {
    git pull --rebase origin main >> "$LOG" 2>&1
    git push origin main >> "$LOG" 2>&1
  }
fi

# Clean up log
rm -f "$LOG"
