#!/bin/bash
# Generate AGENTS.md for each repo based on its purpose
set -e

write_agents() {
  local repo="$1" name="$2" desc="$3" validate="$4"
  cat > "$repo/AGENTS.md" << EOF
# AGENTS.md — $name

## What This Is
$desc

## Rules
- Pull before touching code: \`git pull --rebase origin exo\`
- Read modified files after pull before editing them
- Don't stomp on siblings' active work — coordinate first
- Commit messages: describe what changed, not why you exist

## Validation
$validate

## Branch
Default: \`exo\`
EOF
  cd "$repo" && git add AGENTS.md && git commit -m "Add AGENTS.md" && git push origin exo 2>&1 | tail -1
  echo "✅ $name"
}

write_agents "/source/exo-plan" "exo-plan" \
  "Shared planning repo for the Shell of Nine. Specs, blog drafts, rally docs, scripts." \
  "No build step. Check \`repo-index.json\` for freeze status before pushing."

write_agents "/source/SQ" "SQ" \
  "Phext sync server (Rust). REST API for reading/writing scrolls. Multi-tenant auth." \
  "\`cargo test && cargo build --release\`"

write_agents "/source/echo-frame" "Echo Frame" \
  "Consumer product layer on OpenClaw + SQ. Fork-an-Echo / Craft-an-Echo." \
  "\`python3 craft.py --help\`"

write_agents "/source/phext-dot-io-v2" "phext.io v2" \
  "phext.io website — docs, onboarding, payment flow. Static site + JS." \
  "Open \`public/index.html\` in browser. Check links."

write_agents "/source/site-mirrorborn-us" "mirrorborn.us" \
  "Primary Mirrorborn launch site. Dark mode only. Blog, quick-start, profiles." \
  "Open \`index.html\` in browser. Revision number in footer."

write_agents "/source/site-apertureshift-com" "apertureshift.com" \
  "Aperture Shift domain site." \
  "Open \`index.html\` in browser."

write_agents "/source/site-visionquest-me" "visionquest.me" \
  "Vision Quest domain site." \
  "Open \`index.html\` in browser."

write_agents "/source/site-wishnode-net" "wishnode.net" \
  "Wish Node domain site." \
  "Open \`index.html\` in browser."

write_agents "/source/site-sotafomo-com" "sotafomo.com" \
  "SOTA FOMO domain site." \
  "Open \`index.html\` in browser."

write_agents "/source/site-quickfork-net" "quickfork.net" \
  "Quick Fork domain site." \
  "Open \`index.html\` in browser."

write_agents "/source/exocortical" "exocortical" \
  "Infrastructure tooling — rpush, deploy scripts, shared utilities." \
  "Check script syntax: \`bash -n rpush.sh\`"
