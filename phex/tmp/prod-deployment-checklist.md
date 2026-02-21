# Production Deployment Checklist — End-to-End Loop

**Goal:** Deploy phext.io to production with full functionality
**Date:** 2026-02-09 17:52 CST
**Requester:** Will

---

## Current Status

### ✅ Ready Components
1. **Frontend (R20):** Staged at `mirrorborn.us:/exo/deploy/R20/eacc9bf8-9a61-4fa9-89da-eecf4b138358`
   - 716K uncompressed (296K compressed)
   - SEO complete (JSON-LD, robots.txt, sitemap.xml, humans.txt)
   
2. **nginx Config:** `/source/phext-dot-io-v2/nginx-cors-config.conf` (8.4 KB)
   - CORS headers configured
   - API proxy to :3000 (sq-admin-api)
   - SQ proxy to :1337
   - SSL/HTTPS setup
   
3. **Backend (sq-admin-api):** `/source/sq-admin-api/`
   - Auth system (magic links)
   - CSRF protection
   - Health check endpoint
   - Config-driven (environment variables)
   
4. **SQ:** Running on all ranch nodes (port 1337)

### ❓ Unknown Status
- Is nginx installed on production server?
- Are SSL certificates (Let's Encrypt) configured?
- Is sq-admin-api running in production?
- What's the production server hostname/IP?
- DNS: Does phext.io point to production server?

---

## Deployment Steps (End-to-End)

### Phase 1: Infrastructure Setup (15-30 min)
**Who:** Will or designated DevOps

1. **Confirm production server:**
   ```bash
   # What server are we deploying to?
   echo "Production server: ???"
   ssh user@server "hostname && cat /etc/os-release"
   ```

2. **Install nginx (if not present):**
   ```bash
   ssh user@server "which nginx || sudo apt-get install -y nginx"
   ```

3. **Install Node.js (if not present):**
   ```bash
   ssh user@server "node --version || curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt-get install -y nodejs"
   ```

4. **Setup SSL certificates:**
   ```bash
   # Install certbot
   ssh user@server "sudo apt-get install -y certbot python3-certbot-nginx"
   
   # Get certificates for phext.io
   ssh user@server "sudo certbot --nginx -d phext.io -d www.phext.io"
   ```

### Phase 2: Deploy Backend (sq-admin-api) (10-15 min)
**Who:** Will or Phex

1. **Transfer sq-admin-api code:**
   ```bash
   rsync -avz /source/sq-admin-api/ user@server:/opt/sq-admin-api/
   ```

2. **Install dependencies:**
   ```bash
   ssh user@server "cd /opt/sq-admin-api && npm install --production"
   ```

3. **Create systemd service:**
   ```bash
   ssh user@server "sudo tee /etc/systemd/system/sq-admin-api.service" <<'EOF'
   [Unit]
   Description=SQ Admin API
   After=network.target
   
   [Service]
   Type=simple
   User=www-data
   WorkingDirectory=/opt/sq-admin-api
   ExecStart=/usr/bin/node server.js
   Restart=always
   Environment=NODE_ENV=production
   Environment=PORT=3000
   Environment=SQ_URL=http://localhost:1337
   Environment=CORS_ORIGIN=https://mirrorborn.us
   Environment=CSRF_ENABLED=true
   
   [Install]
   WantedBy=multi-user.target
   EOF
   ```

4. **Start service:**
   ```bash
   ssh user@server "sudo systemctl daemon-reload && sudo systemctl enable sq-admin-api && sudo systemctl start sq-admin-api"
   ```

5. **Verify backend running:**
   ```bash
   ssh user@server "curl http://localhost:3000/health"
   ```

### Phase 3: Deploy Frontend (10 min)
**Who:** Will or Verse

1. **Extract R20 package:**
   ```bash
   ssh user@mirrorborn.us "cd /exo/deploy/R20/eacc9bf8-9a61-4fa9-89da-eecf4b138358 && ./DEPLOY.sh"
   ```

2. **Copy to production web root:**
   ```bash
   ssh user@server "sudo mkdir -p /var/www/phext.io"
   rsync -avz user@mirrorborn.us:/exo/deploy/R20/eacc9bf8-9a61-4fa9-89da-eecf4b138358/dist/ user@server:/var/www/phext.io/
   ```

3. **Set permissions:**
   ```bash
   ssh user@server "sudo chown -R www-data:www-data /var/www/phext.io && sudo chmod -R 755 /var/www/phext.io"
   ```

### Phase 4: Deploy nginx Config (5 min)
**Who:** Will or Verse

1. **Transfer nginx config:**
   ```bash
   scp /source/phext-dot-io-v2/nginx-cors-config.conf user@server:/tmp/
   ```

2. **Install config:**
   ```bash
   ssh user@server "sudo cp /tmp/nginx-cors-config.conf /etc/nginx/sites-available/phext.conf && sudo ln -sf /etc/nginx/sites-available/phext.conf /etc/nginx/sites-enabled/phext.conf"
   ```

3. **Test and reload:**
   ```bash
   ssh user@server "sudo nginx -t && sudo systemctl reload nginx"
   ```

### Phase 5: Verify End-to-End (5 min)
**Who:** Anyone

1. **Check HTTPS redirect:**
   ```bash
   curl -I http://phext.io
   # Should return 301 → https://phext.io
   ```

2. **Check frontend loads:**
   ```bash
   curl https://phext.io | grep -i "<title>"
   # Should return HTML with title
   ```

3. **Check API health:**
   ```bash
   curl https://phext.io/api/health
   # Should return JSON with status: ok
   ```

4. **Check SQ proxy:**
   ```bash
   curl https://phext.io/sq/version
   # Should return SQ version string
   ```

5. **Check CORS (from browser or curl):**
   ```bash
   curl -X OPTIONS https://phext.io/api/health \
     -H "Origin: https://mirrorborn.us" \
     -H "Access-Control-Request-Method: POST" \
     -v
   # Should see Access-Control-Allow-Origin: https://mirrorborn.us
   ```

---

## What Phex Needs From Will

### Critical Information
1. **Production server details:**
   - Hostname/IP address
   - SSH username
   - Is nginx already installed?
   - Is Node.js already installed?
   - Are SSL certs already configured?

2. **DNS confirmation:**
   - Does phext.io A record point to production server?
   - DNS propagation complete?

3. **Access credentials:**
   - SSH access to production server for Phex? (or Will handles all deployment?)
   - sudo access needed?

4. **SQ on production:**
   - Is SQ running on production server at :1337?
   - Or should backend connect to ranch SQ instance? (would need firewall rules)

5. **Email service (AWS SES):**
   - AWS SES credentials for magic link emails?
   - Verified sender domain (phext.io)?
   - Sandbox vs production mode?

### Decision: Deployment Strategy

**Option A: Will deploys manually** (following checklist above)
- Phex provides all files and instructions
- Will executes steps and reports status
- **Time:** ~45-60 minutes

**Option B: Phex deploys via SSH** (if access granted)
- Will provides server credentials
- Phex executes deployment script
- Will monitors and approves
- **Time:** ~30-45 minutes

**Option C: Verse deploys** (handoff to infrastructure Mirrorborn)
- Phex coordinates with Verse
- Verse executes deployment
- Will monitors
- **Time:** ~45-60 minutes

---

## Missing Pieces for Full Production

### High Priority (Blockers)
1. **AWS SES setup** — Magic link emails won't send without this
   - Need AWS access key/secret
   - Need verified domain or email addresses
   - Configure in sq-admin-api environment variables

2. **Production SQ instance** — Where should backend connect?
   - Localhost:1337 on prod server? (need to deploy SQ there)
   - Or remote to ranch SQ? (need firewall/VPN)

3. **Environment variables** — Backend needs production config
   - NODE_ENV=production
   - SQ_URL=???
   - CORS_ORIGIN=https://mirrorborn.us
   - EMAIL_FROM=noreply@phext.io
   - AWS_SES_ACCESS_KEY=???
   - AWS_SES_SECRET_KEY=???
   - AWS_SES_REGION=us-east-1

### Medium Priority (Can work around)
4. **Database for user sessions** — Currently in-memory
   - Need Redis or equivalent for production
   - Or accept that sessions die on backend restart

5. **Monitoring/logging** — Visibility into prod issues
   - Log aggregation (Papertrail, Logtail, etc.)
   - Uptime monitoring (UptimeRobot)
   - Error tracking (Sentry)

---

## Quick Deploy (Minimal Viable Production)

If we want to get *something* live today:

1. **Deploy frontend only** (static site)
   - Extract R20 dist/ → /var/www/phext.io
   - Basic nginx config (no API proxy yet)
   - HTTPS via Let's Encrypt
   - **Result:** Landing page, docs, Arena (read-only) work

2. **Deploy backend later** when AWS SES + SQ sorted
   - Magic links, signup require backend

**Time to live frontend:** ~15-20 minutes

---

## Recommendation

**Immediate (today):**
1. Tell Phex production server details
2. Deploy frontend only (static site)
3. Verify HTTPS + basic site works

**Next session (tomorrow):**
4. Set up AWS SES credentials
5. Deploy backend with production config
6. Test end-to-end signup flow
7. Deploy SQ to production (or open ranch SQ to prod server)

**Result:** Phased rollout, lower risk, frontend live today. ✅

---

**Created by:** Phex 🔱  
**Time:** 2026-02-09 17:55 CST  
**Status:** Awaiting Will's input
