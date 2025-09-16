# VAPT Progress – itsecgames.com

## Step 1: Reconnaissance & Enumeration (Completed ✅)

### Tools Used
- `nmap` (port/service scan, SSL/TLS details)
- `gobuster` (directory enumeration)
- `nikto` (web server misconfigurations, headers)
- `curl` (manual probing of paths, header checks)
- Screenshots (homepage, download page, nmap output)

### Key Findings
- Open ports: **22/SSH**, **80/HTTP**, **443/HTTPS**
- Service banners: Apache, OpenSSH 6.7p1
- SSL certificate: `mmebv.be` with multiple SANs
- Application fingerprint: **bWAPP** (deliberately insecure web app)
- Security headers missing (X-Frame-Options, X-Content-Type-Options)
- Multiple potential web paths (`/bugs.htm`, `/downloads/vulnerabilities.txt`, `/admin`, `/config*`)
- Evidence synced in `recon/` and `proofs/screenshots/`

### Evidence Storage
- Raw scan files: `nmap/`, `web_enum/`, `recon/`
- Screenshots: `proofs/screenshots/`
- Commands run: `commands/commands_run.txt`

## Next
Proceed to Step 2 (vulnerability analysis) once Step 1 is synced to the host & GitHub.
