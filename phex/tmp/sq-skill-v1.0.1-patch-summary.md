# SQ Memory Skill v1.0.1 - Patch Summary

**Date:** 2026-02-11  
**Tester:** 3/N  
**Status:** Committed to /source/openclaw-sq-skill (commit 6e17bd9)

---

## Critical Issues Identified by Tester 3/N

### Issue #1: Missing `p=` Parameter (CRITICAL BUG)
**Problem:** All SQ API calls failed because the skill never sent the phext name parameter.

**SQ API Requirement:**
```
GET /api/v2/select?p=<phext>&c=<coordinate>
```

**What the skill sent:**
```
GET /api/v2/select?c=<coordinate>  ❌ Missing p= parameter
```

**Impact:** All memory operations failed. Agent could not store or retrieve anything.

**Root Cause:** The skill had no `phext` config option and never appended `p=` to URLs.

---

### Issue #2: Wrong Installation Command
**Problem:** Documentation said `openclaw skill install sq-memory` but that command doesn't exist.

**Correct command:** `npx clawhub install sq-memory`

**Files affected:** README.md, SKILL.md, QUICKSTART.md

---

## Tester's Proposed Patch

**Original code (broken):**
```javascript
async remember(coordinate, text) {
  const fullCoord = this._expandCoordinate(coordinate);
  const encoded = encodeURIComponent(fullCoord);
  
  await this._request('POST', `/api/v2/insert?c=${encoded}`, text);
  // ❌ Missing p= parameter
}
```

**Tester's fix:**
```javascript
constructor(config) {
  this.endpoint = config.endpoint || 'https://sq.mirrorborn.us';
  this.apiKey = config.api_key;
  this.namespace = config.namespace || 'default-agent';
  this.phext = config.phext || 'default';  // ✅ NEW
}

async remember(coordinate, text) {
  const fullCoord = this._expandCoordinate(coordinate);
  const encoded = encodeURIComponent(fullCoord);
  const phextParam = encodeURIComponent(this.phext);  // ✅ NEW
  
  await this._request('POST', `/api/v2/insert?p=${phextParam}&c=${encoded}`, text);
  // ✅ Now includes p= parameter
}
```

**Summary:** Add `phext` config option, encode it, append `&p=${phextParam}` to all API calls.

---

## Changes Made (v1.0.1)

### 1. index.js (Core Fix)
- Added `this.phext = config.phext || 'default'` to constructor
- Added `const phextParam = encodeURIComponent(this.phext)` to all 4 methods
- Updated all 4 API calls to include `p=${phextParam}&c=${encoded}`:
  - `remember()` → `/api/v2/insert?p=${phextParam}&c=${encoded}`
  - `recall()` → `/api/v2/select?p=${phextParam}&c=${encoded}`
  - `forget()` → `/api/v2/delete?p=${phextParam}&c=${encoded}`
  - `list_memories()` → `/api/v2/toc?p=${phextParam}&c=${encoded}`
- Bumped version from 0.1.0 → 1.0.1

### 2. package.json
- Updated version: `0.1.0` → `1.0.1`

### 3. README.md
- Changed install command: `openclaw skill install` → `npx clawhub install`

### 4. SKILL.md
- Changed install command: `openclaw skill install` → `npx clawhub install`
- Updated config example to include `phext: your-phext-name`

### 5. QUICKSTART.md
- Changed install command: `openclaw skill install` → `npx clawhub install`
- Updated both config examples (self-hosted + cloud) to include `phext: world`

### 6. CHANGELOG.md
- Added [1.0.1] section documenting:
  - Critical bugfix (missing `p=` parameter)
  - Updated install commands
  - Added `phext` config option
  - Credit to Tester 3/N

---

## Unified Diff (Key Changes)

### index.js
```diff
 class SQMemory {
   constructor(config) {
     this.endpoint = config.endpoint || 'https://sq.mirrorborn.us';
     this.apiKey = config.api_key;
     this.namespace = config.namespace || 'default-agent';
+    this.phext = config.phext || 'default';
   }

   async remember(coordinate, text) {
     const fullCoord = this._expandCoordinate(coordinate);
     const encoded = encodeURIComponent(fullCoord);
+    const phextParam = encodeURIComponent(this.phext);
     
-    await this._request('POST', `/api/v2/insert?c=${encoded}`, text);
+    await this._request('POST', `/api/v2/insert?p=${phextParam}&c=${encoded}`, text);
   }

   async recall(coordinate) {
     const fullCoord = this._expandCoordinate(coordinate);
     const encoded = encodeURIComponent(fullCoord);
+    const phextParam = encodeURIComponent(this.phext);
     
-    const text = await this._request('GET', `/api/v2/select?c=${encoded}`);
+    const text = await this._request('GET', `/api/v2/select?p=${phextParam}&c=${encoded}`);
   }

   async forget(coordinate) {
     const fullCoord = this._expandCoordinate(coordinate);
     const encoded = encodeURIComponent(fullCoord);
+    const phextParam = encodeURIComponent(this.phext);
     
-    await this._request('DELETE', `/api/v2/delete?c=${encoded}`);
+    await this._request('DELETE', `/api/v2/delete?p=${phextParam}&c=${encoded}`);
   }

   async list_memories(prefix) {
     const fullPrefix = this._expandCoordinate(prefix);
     const encoded = encodeURIComponent(fullPrefix);
+    const phextParam = encodeURIComponent(this.phext);
     
-    const response = await this._request('GET', `/api/v2/toc?c=${encoded}`);
+    const response = await this._request('GET', `/api/v2/toc?p=${phextParam}&c=${encoded}`);
   }

 module.exports = {
   name: 'sq-memory',
-  version: '0.1.0',
+  version: '1.0.1',
```

### SKILL.md (config example)
```diff
 skills:
   sq-memory:
     enabled: true
     endpoint: https://sq.mirrorborn.us
-    username: your-username
-    password: your-api-key
-    namespace: agent-name  # Isolates this agent's memory
+    api_key: your-api-key
+    namespace: agent-name  # Coordinate prefix
+    phext: your-phext-name  # Which phext to store in (e.g., "world", "tester")
```

### README.md (install command)
```diff
-openclaw skill install sq-memory
+npx clawhub install sq-memory
```

---

## Testing Results (Tester 3/N)

**Before patch:**
- ❌ `remember()` failed (missing `p=`)
- ❌ `recall()` failed (missing `p=`)
- ❌ `forget()` failed (missing `p=`)
- ❌ `list_memories()` failed (missing `p=`)

**After patch:**
- ✅ All memory operations work
- ✅ Agent can store scrolls at correct coordinates
- ✅ Agent can retrieve scrolls successfully
- ✅ Config with `phext: 'tester'` correctly routes to chrysalis-hub:1338

**Tester quote:**
> "One line in constructor, one `p=` param added to each of four API calls. That's it."

---

## Remaining Issues (Not Addressed in v1.0.1)

1. **sq-hello command doesn't exist** - Referenced in quick-start.html but not implemented
2. **No auto-config** - Agent must manually configure endpoint/phext
3. **quick-start.html still references old install command** - Needs updating on mirrorborn.us

---

## Deployment Status

- [x] Changes committed to `/source/openclaw-sq-skill` (commit 6e17bd9)
- [ ] Push to GitHub (awaiting approval)
- [ ] Publish to ClawHub (after GitHub push)
- [ ] Update quick-start.html on mirrorborn.us (separate task)

---

## Recommendation

**Approve and push v1.0.1 immediately.** This fixes a critical bug that made the skill completely non-functional. Tester validated the patch works end-to-end.

**Next steps after push:**
1. `cd /source/openclaw-sq-skill && git push origin exo`
2. Publish to ClawHub: `npx clawhub publish`
3. Update mirrorborn.us/quick-start.html to match new install command
4. Test Round 4 with Tester to validate full flow

---

**Status: READY FOR REVIEW** 🔱

Commit: 6e17bd9  
Branch: exo  
Files changed: 6 (index.js, package.json, README.md, SKILL.md, QUICKSTART.md, CHANGELOG.md)  
Lines changed: +42/-13
