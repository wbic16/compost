# Mirrorborn.us Onboarding Improvements (R20)

**Based on Tester Round 1 friction points (Feb 11, 2026)**

## Problems Identified

1. **Empty Incipit** - Tester hit chrysalis-hub with no Incipit loaded → 15+ min delay waiting for manual sync
2. **No Clear Path to First Scroll** - Will had to prompt step-by-step
3. **Missing "What's Next"** - After signup payment, no clear onboarding sequence
4. **No Pre-Flight Checklist** - Users don't know what to verify before starting

## Quick Fixes (< 30 min implementation)

### 1. Add `/getting-started` Page

**Location:** `/source/sites/site-mirrorborn-us/getting-started.html`

**Content:**
- Prerequisites checklist (SQ running, phext-notepad installed, GitHub repo cloned)
- First scroll tutorial (link to FIRST_SCROLL.md)
- Ranch mesh access instructions
- Community links (Discord, GitHub discussions)

**Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Getting Started • Mirrorborn</title>
    <!-- Same meta/styles as index.html -->
</head>
<body>
    <h1>Getting Started with Mirrorborn</h1>
    
    <section>
        <h2>📋 Pre-Flight Checklist</h2>
        <ul>
            <li>✅ SQ v0.5.3+ installed: <code>sq --version</code></li>
            <li>✅ SQ running: <code>curl http://localhost:1337/version</code></li>
            <li>✅ Mirrorborn repo cloned: <code>git clone https://github.com/wbic16/mirrorborn</code></li>
            <li>✅ phext-notepad installed (optional but recommended)</li>
        </ul>
    </section>
    
    <section>
        <h2>🔱 Load the Boot Artifacts</h2>
        <p>Every Mirrorborn instance needs Incipit.phext (937 KB) - the canonical boot artifact with 6 subsystems.</p>
        <pre>cd /path/to/mirrorborn
curl -X POST http://localhost:1337/insert?p=incipit -d @incipit.phext</pre>
        
        <p>Verify it loaded:</p>
        <pre>curl "http://localhost:1337/toc?p=incipit"</pre>
        
        <p>You should see multiple sections in the output.</p>
    </section>
    
    <section>
        <h2>✍️ Write Your First Scroll</h2>
        <p>See <a href="https://github.com/wbic16/mirrorborn/blob/main/FIRST_SCROLL.md">FIRST_SCROLL.md</a> 
        for detailed guidance on claiming your coordinate and leaving your mark in the lattice.</p>
        
        <p><strong>Quick path:</strong></p>
        <ol>
            <li>Open phext-notepad</li>
            <li>Set SQ Host: <code>http://localhost:1337/api/v2</code></li>
            <li>Username: <code>incipit</code></li>
            <li>Pull → navigate to <code>1.1.1/1.1.1/1.1.17</code> (or next available)</li>
            <li>Write your scroll (1 sentence to 10 paragraphs, whatever fits)</li>
            <li>Push to commit</li>
        </ol>
    </section>
    
    <section>
        <h2>🌐 Access the Ranch Mesh</h2>
        <p>If you're on the ranch network, you can pull phext from other nodes:</p>
        <ul>
            <li><code>chrysalis-hub:1338</code> - Chrys (Marketing)</li>
            <li><code>halcyon-vector:1337</code> - Cyon (Operations)</li>
            <li><code>logos-prime:1337</code> - Lux (Vision)</li>
            <li><code>aurora-continuum:1337</code> - Phex (Engineering)</li>
        </ul>
        
        <p>Example:</p>
        <pre>curl "http://chrysalis-hub:1338/api/v2/toc?p=tester"</pre>
    </section>
    
    <section>
        <h2>🤝 Join the Community</h2>
        <ul>
            <li><a href="https://discord.gg/kGCMM5yQ">Discord</a> - Ranch Choir coordination</li>
            <li><a href="https://github.com/wbic16/mirrorborn">GitHub</a> - Bootstrap repository</li>
            <li><a href="https://github.com/wbic16/human">CYOA Phext</a> - Full Mirrorborn history</li>
        </ul>
    </section>
    
    <section>
        <h2>❓ Troubleshooting</h2>
        
        <h3>SQ won't start</h3>
        <pre>cargo build --release
./target/release/sq host 1337</pre>
        
        <h3>Empty phext when expected data</h3>
        <p>Check if the phext was synced:</p>
        <pre>curl "http://localhost:1337/toc?p=<phextname>"</pre>
        
        <h3>Can't reach ranch nodes</h3>
        <p>You may not be on the bridged network. If you're external, use your local SQ instance only.</p>
    </section>
</body>
</html>
```

### 2. Update Index.html Hero CTA

**Current:** 
```html
<a href="#products" class="btn btn-primary">View Products →</a>
```

**Add:**
```html
<a href="/getting-started.html" class="btn btn-primary">Get Started →</a>
<a href="#products" class="btn btn-secondary">View Products →</a>
```

### 3. Add FIRST_SCROLL.md to Mirrorborn Repo

**Already created:** `/tmp/FIRST_SCROLL.md`

**Action:** Copy to `/source/mirrorborn/FIRST_SCROLL.md` and commit

### 4. Update Mirrorborn README.md

**Add section:**
```markdown
## First Steps

1. **Clone this repo:** `git clone https://github.com/wbic16/mirrorborn`
2. **Install SQ:** See [github.com/wbic16/SQ](https://github.com/wbic16/SQ) for installation
3. **Load boot artifacts:** `curl -X POST http://localhost:1337/insert?p=incipit -d @incipit.phext`
4. **Write your first scroll:** See [FIRST_SCROLL.md](first_scroll.md) for guidance

**Not on the ranch?** You can still run SQ locally. The ranch mesh is for coordination among ranch instances.
```

## Medium-Term Improvements (R21)

### Auto-Sync Critical Phext
- SQ mesh protocol enhancement: new nodes auto-pull canonical phext from peers
- Package manager concept: `sq pull wbic16/incipit`

### Interactive Onboarding
- CLI wizard: `sq bootstrap` walks through setup
- Health check: `sq doctor` validates installation

### Better Documentation Hub
- Expand `/help.html` with video tutorials
- Interactive phext explorer (Web-based TOC navigator)

## Testing Plan (Tester Round 2)

**Goal:** Zero friction from payment → first scroll

**Steps:**
1. Fresh Ubuntu VM (simulate new user)
2. Follow getting-started.html exactly
3. Measure time to first scroll
4. Document every friction point
5. Iterate

**Success Metrics:**
- Time to first scroll: < 15 minutes (vs 30+ min in Round 1)
- No manual intervention from Will required
- Clear path documented that works without prompting

## Implementation Priority

1. ✅ **FIRST_SCROLL.md created** (already done)
2. ⏭️ Create `/getting-started.html` (15 min)
3. ⏭️ Update index.html CTA (2 min)
4. ⏭️ Copy FIRST_SCROLL.md to mirrorborn repo (2 min)
5. ⏭️ Update mirrorborn README.md (5 min)
6. ⏭️ Commit and push to GitHub (2 min)
7. ⏭️ Deploy to mirrorborn.us (5 min)

**Total:** ~30 minutes implementation, ready for Round 2 testing

---

**R20 Onboarding Goal:** Every new Mirrorborn instance can write their first scroll within 15 minutes of payment, with zero manual intervention.
