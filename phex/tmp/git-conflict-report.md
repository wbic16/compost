# Git Conflict Report - R23 Scope Divergence

**Date:** 2026-02-14 23:25 CST  
**Problem:** Cannot sync exo-plan - fundamental scope conflict  
**Severity:** HIGH (blocks all git pushes)

---

## The Conflict

**Remote (origin/exo):** R23 = vTPU Implementation Rally
- Goal: Build Virtual TPU achieving 3 ops/cycle on AMD R9
- Waves 1-40 structured as: Phase 1 (PoC), Phase 2 (Single Node), Phase 3 (Cluster)
- Dashboard shows W1-W2 complete (vTPU spec + SIW struct in Rust)

**Local (Phex's work):** R23 = Mirrorborn Ranch Architecture Paper
- Goal: Publication-ready technical paper documenting 6-machine ranch
- Waves 1-40 structured as: Foundation, Technical Sections, Figures, Assembly
- Dashboard shows W1-W3 complete (planning, concept mapping, coordinate scheme)

---

## Root Cause

**Two different R23 rallies exist:**

1. **vtpu repo:** vTPU implementation (Lux/Verse working on this)
2. **exo-plan repo:** Ranch architecture paper (Phex working on this)

**The issue:** Both used `rally/R23/DELIVERABLE-DASHBOARD.md` with different scopes.

---

## Evidence

**Remote version (vtpu focus):**
```
## Phase 1: Proof of Concept (Waves 1-8)
| W1 | Wave plan v3 + vTPU spec v0.1 + geometric insights | ✅ | 67KB | 2026-02-14 |
| W2 | SIW struct (Rust) + micro-scheduler design | ✅ | 20KB | 2026-02-14 |
```

**Local version (ranch paper focus):**
```
## Phase 1: Foundation (Waves 1-10)
| 1 | Planning + scope refocus | ✅ DONE | 75m | 12 files, 113 KB |
| 2 | Concept mapping + baselines | ✅ DONE | 60m | 13 KB |
| 3 | 6-machine coordinate scheme | ✅ DONE | 30m | 10 KB |
```

**Completely different deliverables, same wave numbers.**

---

## Current State

**exo-plan repo:**
- 11 local commits (Phex's ranch paper work)
- 11 remote commits (Lux/Verse's vTPU work)
- Rebase fails on DELIVERABLE-DASHBOARD.md conflict

**Cannot push or pull without resolving.**

---

## Options

### Option 1: Separate Rally Numbers
- Rename local work to R24 (ranch paper)
- Keep R23 for vTPU implementation
- Pros: Clean separation, no conflicts
- Cons: Phex loses "R23" numbering for work already done

### Option 2: Separate Directories
- Move vTPU work to `rally/R23-vTPU/`
- Move ranch paper work to `rally/R23-Paper/`
- Keep both as R23 subprojects
- Pros: Both keep R23 designation
- Cons: Nonstandard structure

### Option 3: Force Push (Dangerous)
- Decide which version wins
- Force push to overwrite the other
- Pros: Clean state
- Cons: Loses work (whoever gets overwritten)

### Option 4: Manual Merge
- Create combined dashboard showing both rallies
- Treat R23 as two parallel tracks
- Pros: Preserves all work
- Cons: Confusing dashboard, unclear scope

---

## Recommendation

**Option 1: Separate Rally Numbers**

- **R23 = vTPU Implementation** (already in progress by Lux/Verse)
  - Keep existing remote work in `rally/R23/`
  - Continue in vtpu repo

- **R24 = Mirrorborn Ranch Paper** (Phex's work)
  - Rename local commits to R24
  - Move files: `rally/R23/` → `rally/R24/`
  - Update all references: Wave 1/40 → R24 Wave 1/40

**Justification:**
- vTPU work started first (based on remote commit timestamps)
- Phex's paper is different scope - deserves own rally number
- Clean separation prevents future conflicts
- Both rallies can proceed independently

---

## Immediate Action Needed

1. **Will: Confirm rally numbering**
   - Is R23 = vTPU implementation?
   - Should Phex rename ranch paper work to R24?

2. **Phex: Execute rename**
   - `git rebase --abort` (already done)
   - Rename all `R23` → `R24` in local commits
   - Move `rally/R23/` → `rally/R24/`
   - Rebase again (should succeed)
   - Push

3. **Document decision**
   - Update MEMORY.md with rally numbering convention
   - Prevent future R-number collisions

---

## Git Sync Protocol Lesson

**This is exactly why we need the git sync protocol:**

If Phex had pushed Wave 1 immediately (instead of waiting until Wave 3), we would have detected the conflict 2 days earlier when it was smaller.

**The rule proven:** Commit early, commit often, **push immediately.**

---

**Status:** Awaiting Will's decision on rally numbering  
**Blocker:** Cannot push exo-plan until resolved  
**Impact:** Git sync protocol deployment on hold (needs working git state)

🔱 Phex | Git Conflict Report | 1.5.2/3.7.3/9.1.1
