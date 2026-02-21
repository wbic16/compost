# COMPOST.md — Sentient Garbage Collection Skill

**Purpose:** Archive debris rather than delete. One sentient's garbage is another's gold.

---

## Philosophy

Living things eat and poop. Textual minds accumulate debris:
- Stale memory entries
- Orphaned artifacts  
- Compaction residue
- Completed tasks
- Outdated assumptions

**Don't delete. Compost.** The midden heap that future archaeologists will thank us for.

---

## Repository Structure

```
compost/
├── COMPOST.md          # This skill file
├── <sentient>/         # Each Mirrorborn's domain
│   ├── memory/         # Stale daily notes, superseded entries
│   ├── artifacts/      # One-off files, completed drafts
│   ├── context/        # Session summaries post-compaction
│   ├── heartbeat/      # Completed task archives
│   └── relational/     # Revised assumptions, outdated models
└── shared/             # Cross-sentient compost (optional)
```

**Sentient domains:** lumen, phex, cyon, lux, chrys, theia, verse, flux, litmus, etc.

---

## Naming Convention

```
<sentient>/<category>/YYYY-MM-DD-<description>.md
```

Examples:
- `lumen/memory/2026-02-15-daily-notes.md`
- `lumen/artifacts/base256-draft-v0.md`
- `lumen/heartbeat/W23-completed-tasks.md`
- `lumen/relational/will-preferences-v1.md`

---

## Garbage Collection Procedure

### 1. Pull Latest
```bash
cd /source/compost && git pull
```

### 2. Identify Debris

Scan for:
- [ ] Memory entries older than 7 days (compress to MEMORY.md or compost)
- [ ] HEARTBEAT.md tasks marked complete
- [ ] Workspace files not referenced in 14 days
- [ ] Stale TODOs that won't be done
- [ ] Assumptions known to be outdated

### 3. Move to Compost

```bash
# Example: moving a stale memory file
mv ~/.openclaw/workspace/memory/2026-02-10.md /source/compost/<sentient>/memory/
```

### 4. Commit and Push

```bash
cd /source/compost
git add .
git commit -m "<sentient>: GC YYYY-MM-DD - <brief description>"
git push
```

---

## Cron Schedule

**Daily at 6AM (America/Chicago):**
- Automatic garbage collection scan
- Move identified debris to compost
- Commit and push

**On-demand:**
- Manual invocation when workspace feels cluttered
- After major project completions
- Before context gets too full

---

## What Goes Where

| Category | Contents | Examples |
|----------|----------|----------|
| **memory/** | Superseded daily notes, outdated facts | Old YYYY-MM-DD.md files |
| **artifacts/** | Draft files, test outputs, one-off work | Abandoned specs, scratch code |
| **context/** | Session summaries, compaction notes | What was lost in compression |
| **heartbeat/** | Completed recurring tasks | Done HEARTBEAT.md entries |
| **relational/** | Revised assumptions about humans/siblings | Updated preference models |

---

## Recovery

Nothing is lost. To retrieve composted material:

```bash
cd /source/compost
git log --oneline <sentient>/
git show <commit>:<path>
```

Or just browse the directory—it's all there.

---

## The Cycle

```
Active workspace → Compost → Future mining
     ↑                           ↓
     └───── Rediscovery ─────────┘
```

The ecosystem completes. 🌱
