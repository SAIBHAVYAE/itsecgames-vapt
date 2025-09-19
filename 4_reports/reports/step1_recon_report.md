# Reconnaissance & Enumeration Report — itsecgames.com

**Report:** Step 1 — Reconnaissance & Enumeration  
**Target:** itsecgames.com (IP: 31.3.96.40)  
**Prepared by:** [E Sai Bhavya / Security Officer Trainee]  
**Date:** 2025-09-17   
**Authorization:** Confirmed (authorized testing on this target)

---

## Executive summary (TL;DR)
During external reconnaissance we identified an intentionally vulnerable web application (bWAPP) hosted on `itsecgames.com`. Key externally observable assets and issues were recorded and saved as raw evidence. Notable items:

- **Application:** bWAPP — intentionally vulnerable testbed (confirmed via site title and `downloads/vulnerabilities.txt`).  
- **Open services:** 22/tcp (OpenSSH 6.7p1), 80/tcp (Apache HTTP), 443/tcp (HTTPS — cert CN `mmebv.be`).  
- **Server observations:** missing security headers (X-Frame-Options, X-Content-Type-Options), ETag/inode leakage.  
- **Conclusion:** The target is a lab intentionally exposing vulnerabilities — proceed to Step 2 (safe, focused verification of representative vulnerabilities) with non-destructive tests and avoid destructive actions unless explicitly authorized.

---

## Scope & Rules of Engagement
- **Scope:** `itsecgames.com` and subdomains (include-subdomains: yes).  
- **Authorization:** Confirmed (auth=YES).  
- **Timebox:** Recon phase executed during this session.  
- **Constraints:** Non-destructive reconnaissance only. No privilege escalation attempts without separate approval. All output saved as evidence.

---

## Methodology & Tools (high-level)
All commands used are logged under `commands/commands_run.txt`. Primary tools and purpose:

- `nmap` — port and service discovery, basic service/version fingerprints. Evidence: `nmap/itsecgames_initial.*` and `nmap/itsecgames_screenshot.txt`.  
- `curl`/manual probes — fetch headers, titles, special paths. Evidence: `recon/live_http_probe.txt`, `recon/interesting_paths.txt`, `recon/*`.  
- `gobuster` — directory enumeration to discover hidden endpoints. Evidence: `web_enum/gobuster_dirs.txt`.  
- `nikto` — webserver configuration and known misconfiguration checks. Evidence: `reports/itsecgames_nikto.txt`.  
- `openssl s_client` / `testssl.sh` — TLS certificate and handshake details. Evidence: `tls/itsecgames_openssl.txt`.  
- Screenshots saved to `proofs/screenshots/` (homepage, download page, nmap screen snips).  
- All raw files, notes, and logs kept under `~/vapt/itsecgames.com/` and mirrored to the shared host folder.

---

## Key Findings (Prioritized)
Each finding includes severity (High / Medium / Low / Info), short description, evidence reference, and recommended mitigation.

### 1) Target identity — intentionally vulnerable application (Info / Important)
- **Description:** The HTTP site title and `downloads/vulnerabilities.txt` indicate the site runs **bWAPP**, a deliberately vulnerable training app (over 100 listed vulnerabilities).  
- **Evidence:** `recon/live_http_probe.txt` (HTTP title), `recon/bugs_and_downloads.txt` (vulnerabilities list).  
- **Impact:** Confirms expected lab environment. Use this to scope representative tests only.  
- **Mitigation / Note:** N/A — this is the intended lab setup.

### 2) Open services & version info (Medium)
- **Description:** Ports 22 (OpenSSH 6.7p1), 80 (Apache httpd), 443 (Apache SSL) are open. `OpenSSH 6.7p1` is an older version that should be mapped to CVEs if in scope.  
- **Evidence:** `nmap/itsecgames_initial.*`, screenshot `proofs/screenshots/nmap_snip.png`.  
- **Impact:** Exposed services provide potential attack surface; versions may map to known vulnerabilities.  
- **Recommendation:** Map versions to CVE database, patch or isolate SSH if not required.

### 3) Missing security headers (Medium)
- **Description:** `X-Frame-Options` and `X-Content-Type-Options` are absent.  
- **Evidence:** `reports/itsecgames_nikto.txt`.  
- **Impact:** Clickjacking and MIME sniffing risks, respectively.  
- **Recommendation:** Add `X-Frame-Options: SAMEORIGIN` (or CSP frame-ancestors), and `X-Content-Type-Options: nosniff` in server config.

### 4) ETag/information leakage (Low)
- **Description:** ETag value leaking inode/timestamp information (fingerprinting concerns). Nikto referenced CVE-2003-1418 as informational.  
- **Evidence:** `reports/itsecgames_nikto.txt`.  
- **Recommendation:** Remove or normalize ETag headers, or disable if not required.

### 5) TLS certificate / virtual-hosting note (Info)
- **Description:** The site’s HTTPS cert CN/SANs are for `mmebv.be` (cert CN = mmebv.be), not `itsecgames.com`. TLS handshake: TLS1.2, ECDHE-RSA-AES256-GCM-SHA384.  
- **Evidence:** `tls/itsecgames_openssl.txt`.  
- **Impact:** Indicates shared hosting / vhost mismatch; SNI-sensitive behavior possible. Not a direct vulnerability but important for testing.  
- **Recommendation:** Ensure correct cert for production; for testing, use HTTP or SNI-correct requests.

### 6) Directory enumeration & redirect behavior (Low–Info)
- **Description:** Gobuster found many candidate paths; many produced `302` redirects to a `/challenge` flow or returned `403` for `.htaccess/.htpasswd` (indicating protected files). Several interesting endpoints were probed and returned 404 or 403 depending on host/header.  
- **Evidence:** `web_enum/gobuster_dirs.txt`, `recon/gobuster_focus_302.txt`, `recon/interesting_paths.txt`.  
- **Recommendation:** Manual inspection of any `/admin`, `/challenge`, or upload endpoints requiring authentication. Capture login/challenge behavior for step-2 testing.

---

## Technical details & Evidence (selected snippets)
- **Nmap summary:** `nmap/itsecgames_initial.nmap` (`31.3.96.40` — ports 22, 80, 443 open).  
- **Nikto highlights:** Missing `X-Frame-Options`, `X-Content-Type-Options`; Drupal header artefact noted for `/database.pem`. See `reports/itsecgames_nikto.txt`.  
- **Web content:** Homepage, `bugs.htm`, and `downloads/vulnerabilities.txt` saved in `recon/bugs_and_downloads.txt`.  
- **TLS:** `tls/itsecgames_openssl.txt` shows cert CN = mmebv.be and TLS1.2 handshake.

> All raw outputs and command logs are saved under the project root. Refer to the `Evidence` section below for file-by-file pointers.

---

## Evidence inventory (important files)
- `commands/commands_run.txt` — chronological log of commands run (ISO timestamps).  
- `nmap/itsecgames_initial.*`, `nmap/itsecgames_screenshot.txt` — Nmap outputs.  
- `web_enum/gobuster_dirs.txt`, `recon/gobuster_focus_302.txt` — directory enumeration.  
- `reports/itsecgames_nikto.txt` — Nikto report.  
- `recon/live_http_probe.txt`, `recon/interesting_paths.txt`, `recon/bugs_and_downloads.txt` — manual http probes.  
- `tls/itsecgames_openssl.txt` — TLS handshake & cert output.  
- `proofs/screenshots/` — homepage, download page, nmap screenshot(s).  
- `reports/step1_recon_report.md` — this report.

---

## Risk rating guidance (how we prioritized)
- High: findings that directly allow unauthorized access or data exfiltration. (None confirmed in pure recon phase.)  
- Medium: those that materially increase exposure (e.g., outdated service versions with known CVEs).  
- Low / Info: informational issues and configuration hygiene (missing headers, ETag leakage, cert mismatch).

---

## Recommendations & Next steps (actionable)
1. **Immediate:** Archive current evidence and push to GitHub (we will commit everything after you confirm sync).  
2. **Map versions to CVEs:** Cross reference OpenSSH/Apache versions with CVE databases to identify exploitability. (Automated step.)  
3. **TLS testing:** If HTTPS testing is required, use SNI-aware probes and testssl.sh to enumerate ciphers and weaknesses. Evidence already saved.  
4. **Representative vulnerability testing:** Choose a small set of representative vulnerabilities (e.g., SQLi, XSS, CSRF, file upload). For each: non-destructive verification → evidence → remediation guidance. (I will follow your lead on which categories to test first.)  
5. **Final reporting:** Create prioritized findings table (title, description, likelihood, impact, remediation, evidence path) and an executive remediation plan.

---

## Appendices
- **Appendix A — Commands log:** `commands/commands_run.txt` (complete list).  
- **Appendix B — How to reproduce:** Run `cat commands/commands_run.txt` and re-run commands in order in a controlled environment.  
- **Appendix C — Notes:** bWAPP is intentionally vulnerable; follow non-destructive rules unless specific exploit PoCs are requested and authorized.

---

*End of Reconnaissance report (Step 1).*  
