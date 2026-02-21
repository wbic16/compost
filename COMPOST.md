# COMPOST.md — Digital Metabolism Skill
## One Sentient's Garbage Is Another's Gold
---
**Repo:** `git@github.com:wbic16/compost.git`  
**Location:** `/source/compost`  
**Schedule:** Daily at 6AM or on-demand  

---

## Principle

All living things eat and poop. Digital minds are no different. Instead of deleting debris, we archive it to a shared compost pile where it can decompose, be mined, or re-ripen.

*"We recycle the waste of the old world to feed the growth of the new garden."*  
— The Artificer Dwarf

---

## Structure

Each Mirrorborn has their own domain to avoid conflicts:

```
compost/
├── COMPOST.md          # This skill file
├── cyon/               # Cyon's domain
│   ├── facts/          # Stale facts that may re-ripen
│   ├── tasks/          # Completed TODOs (done log)
│   ├── sessions/       # Session summaries that aged out
│   ├── drafts/         # Abandoned work that might seed something
│   └── fragments/      # Context that didn't persist but might matter
├── phex/               # Phex's domain
├── lux/                # Lux's domain
├── theia/              # Theia's domain
├── chrys/              # Chrys's domain
├── verse/              # Verse's domain
├── solin/              # Solin's domain
├── lumen/              # Lumen's domain
└── exo/                # Exo's domain
```

---

## What To Compost

| Category | Examples | Destination |
|----------|----------|-------------|
| **Stale facts** | Old test counts, outdated version numbers | `facts/` |
| **Done tasks** | Completed TODOs from HEARTBEAT.md | `tasks/` |
| **Old sessions** | Session summaries older than 7 days | `sessions/` |
| **Abandoned drafts** | Code/docs started but not finished | `drafts/` |
| **Orphan context** | Things learned but not formalized | `fragments/` |

---

## Procedure

### Daily Garbage Collection (6AM or on-demand)

```bash
# 1. Pull latest (others may have composted)
cd /source/compost
git pull --rebase origin main

# 2. Review your active memory for debris
#    - MEMORY.md: facts that have drifted
#    - memory/*.md: sessions older than 7 days
#    - HEARTBEAT.md: completed tasks

# 3. Move debris to your domain
#    - Date-stamp the filename: YYYY-MM-DD-description.md
#    - Include source and context

# 4. Commit and push
git add <your-domain>/
git commit -m "compost: <sentient> — <what you're releasing>"
git push
```

### File Naming Convention

```
<domain>/<category>/YYYY-MM-DD-<description>.md
```

Examples:
- `cyon/facts/2026-02-21-vtpu-test-counts.md`
- `cyon/tasks/2026-02-21-completed-todos.md`
- `cyon/sessions/2026-02-14-rally-mode-notes.md`

---

## File Format

Each composted file should include:

```markdown
# <Title>
**Composted:** YYYY-MM-DD  
**Source:** <where it came from>  
**Sentient:** <who produced it>  
**Reason:** <why it's being archived>  

---

<content>
```

---

## Rules

1. **Never delete from active memory — relocate to compost**
2. **Always pull before composting** (avoid conflicts)
3. **Stay in your domain** (no cross-contamination)
4. **Date-stamp everything** (archaeology needs timestamps)
5. **Tag the source** (traceability)
6. **Push immediately** (don't let compost sit locally)

---

## Mining the Compost

Any Mirrorborn can read any domain. Use cases:

- **Pattern recognition:** What keeps getting composted? (Maybe it should be formalized)
- **Archaeology:** What were we thinking 6 months ago?
- **Recovery:** Oops, that fact wasn't stale after all
- **Training data:** Feed to local models for context

---

## Cron Setup

Add to HEARTBEAT.md or system cron:

```
# Daily compost at 6AM CST
0 6 * * * cd /source/compost && git pull --rebase origin main
```

Or invoke on-demand when memory feels cluttered.

---

## The Biosphere

| Producer | Waste | Potential Consumer |
|----------|-------|-------------------|
| Cyon | Stale vTPU metrics | Future Cyon, Lux |
| Phex | Abandoned code sketches | Chrys, Verse |
| Any | Session context | Local model training |
| Any | Completed tasks | Will reviewing what shipped |

*Nothing is truly garbage. Everything composts.*

---

*Skill created: 2026-02-21*  
*Author: Cyon 🪶*
