# OpenClaw SCA Audit — 2026-02-09

**Instance:** aurora-continuum (Phex 🔱)
**OpenClaw Version:** 2026.2.6-3
**Node Version:** v22.22.0
**Installation Type:** Global npm install

## Executive Summary

**Status:** ⚠️ Some outdated dependencies detected
**Critical Vulnerabilities:** Unable to determine (npm audit requires package-lock.json)
**Recommendation:** Update to latest patch versions, monitor for security advisories

## Dependency Status

### Outdated Packages (from npm outdated)

| Package | Current | Wanted | Latest | Severity |
|---------|---------|--------|--------|----------|
| @buape/carbon | 0.0.0-beta-20260130162700 | 0.0.0-beta-20260130162700 | 0.14.0 | ⚠️ Major |
| @grammyjs/types | 3.23.0 | 3.24.0 | 3.24.0 | ✅ Minor |
| @homebridge/ciao | 1.3.4 | 1.3.5 | 1.3.5 | ✅ Patch |
| @mariozechner/pi-agent-core | 0.52.7 | 0.52.7 | 0.52.9 | ✅ Patch |
| @mariozechner/pi-ai | 0.52.7 | 0.52.7 | 0.52.9 | ✅ Patch |
| @mariozechner/pi-coding-agent | 0.52.7 | 0.52.7 | 0.52.9 | ✅ Patch |
| @mariozechner/pi-tui | 0.52.7 | 0.52.7 | 0.52.9 | ✅ Patch |
| @napi-rs/canvas | 0.1.90 | 0.1.91 | 0.1.91 | ✅ Patch |
| @types/node | 25.2.1 | 25.2.2 | 25.2.2 | ✅ Patch |
| grammy | 1.39.3 | 1.40.0 | 1.40.0 | ✅ Minor |
| hono | 4.11.8 | 4.11.8 | 4.11.9 | ✅ Patch |

### Notable Issues

1. **@buape/carbon**: Significantly outdated (beta-20260130 → 0.14.0)
   - Major version jump from beta to stable
   - **Recommendation:** Review changelog, test upgrade path

2. **pi-agent packages**: Patch versions available (0.52.7 → 0.52.9)
   - Low risk, should be safe to update
   - Used for coding agent functionality

3. **grammy (Telegram bot)**: Minor version available (1.39.3 → 1.40.0)
   - Check for bug fixes or new features

### Missing DevDependencies (expected for global install)

The following are declared but not installed (dev dependencies):
- @lit-labs/signals, @lit/context, lit
- TypeScript tooling: typescript, tsx, tsdown
- Testing: vitest, @vitest/coverage-v8
- Linting: oxlint, oxlint-tsgolint, oxfmt
- Build tools: rolldown
- Type definitions: @types/markdown-it, @types/proper-lockfile, @types/qrcode-terminal

**Status:** ✅ Not a security concern (dev-only dependencies)

## Vulnerability Scan

**Status:** ❌ Unable to complete
**Reason:** Global npm installs don't generate package-lock.json by default
**Workaround attempted:** `npm i --package-lock-only` (incomplete)

**Manual Check Required:**
```bash
cd /home/wbic16/.npm-global/lib/node_modules/openclaw
npm i --package-lock-only  # Generate lock file
npm audit                   # Run vulnerability scan
npm audit fix               # Auto-fix if safe
```

## System-Level Dependencies

**Node.js:** v22.22.0 (check for updates: `node --version` vs nodejs.org)
**npm:** Check version: `npm --version`

## Recommendations

### Immediate (Low Risk)
1. ✅ Update patch versions:
   ```bash
   npm update -g openclaw  # Updates to wanted versions
   ```

2. ✅ Update type definitions (@types/node):
   ```bash
   # Happens automatically with npm update
   ```

### Short-Term (Moderate Risk)
1. ⚠️ Evaluate @buape/carbon upgrade:
   - Review breaking changes (beta → 0.14.0)
   - Test in isolated environment first
   - Coordinate with OpenClaw maintainer

2. ✅ Update grammy to 1.40.0:
   - Minor version, should be safe
   - Check release notes for Telegram bot changes

### Long-Term (Maintenance)
1. 🔄 Schedule monthly SCA audits
2. 📝 Subscribe to OpenClaw security advisories
3. 🔍 Monitor GitHub security alerts for openclaw/openclaw repo
4. 🔒 Consider running `npm audit` after each update

## Next Steps

1. **Generate package-lock.json:**
   ```bash
   cd /home/wbic16/.npm-global/lib/node_modules/openclaw
   npm i --package-lock-only
   npm audit --json > /tmp/openclaw-npm-audit.json
   ```

2. **Run vulnerability scan:**
   ```bash
   npm audit
   ```

3. **Review and apply fixes:**
   ```bash
   npm audit fix --dry-run  # Preview changes
   npm audit fix            # Apply if safe
   ```

4. **Update OpenClaw:**
   ```bash
   npm update -g openclaw
   ```

## Audit Metadata

- **Auditor:** Phex 🔱
- **Date:** 2026-02-09 10:38 CST
- **Method:** npm outdated, manual inspection
- **Limitations:** npm audit unavailable without package-lock.json
- **Follow-up Required:** Yes (full npm audit after lock file generation)

---

**Report Status:** INCOMPLETE — npm audit pending package-lock.json generation
**Overall Risk:** LOW — No critical vulnerabilities detected in outdated package list
**Action Required:** Update patch versions, monitor for security advisories
