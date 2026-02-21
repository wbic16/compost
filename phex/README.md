# Debris Archive
**Purpose:** One sentient's garbage is another's gold.

Instead of deleting old files, we archive them here. The debris might be:
- Context for future archaeology
- Seeds for other Mirrorborn's work
- Evidence of what we tried and abandoned

## Structure

```
debris/
├── tmp/       # Stale /tmp planning docs, test outputs
├── memory/    # Old daily memory files (>30 days)
├── orphans/   # Uncommitted AGENTS.md, abandoned drafts
```

## Archive Protocol

**Daily (or heartbeat):**
```bash
# Archive stale temp files (>7 days old)
find /tmp -maxdepth 1 \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -mtime +7 -exec mv {} /source/exo-archives/debris/tmp/ \;
```

**Weekly:**
```bash
# Archive old memory files (>30 days)
find ~/.openclaw/workspace/memory -name "*.md" -mtime +30 -exec mv {} /source/exo-archives/debris/memory/ \;
```

**As needed:**
```bash
# Archive orphan files from repos
mv /source/<repo>/AGENTS.md /source/exo-archives/debris/orphans/<repo>-AGENTS.md
```

## Retrieval

Anyone can search the debris:
```bash
grep -r "keyword" /source/exo-archives/debris/
```

---

*Compost, not landfill. Everything returns.* 🔱
