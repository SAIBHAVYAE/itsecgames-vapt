# ITSecGames VAPT – bWAPP Lab Project

This repository contains a structured Vulnerability Assessment & Penetration Testing (VAPT) project performed on **bWAPP (itsecgames.com)** running in a controlled lab environment.  
The goal of this project is to demonstrate end-to-end security testing: from reconnaissance to exploitation, reporting, and remediation recommendations.

---

## 📌 Project Objectives
- Perform reconnaissance and enumeration on `itsecgames.com`.
- Detect and validate vulnerabilities in the bWAPP application.
- Capture reproducible Proofs of Concept (PoCs).
- Provide remediation guidance for each finding.
- Deliver a professional report and supporting artifacts.

---

## 📂 Repository Structure

```
itsecgames-vapt/
│
├── 1_recon/                       # Reconnaissance outputs (nmap, nikto, gobuster, etc.)
├── 2_vulnerability_detection/     # Detected vulnerabilities with proofs
│   └── proofs/
│       └── detected_vulnerabilities/
│           ├── sqli_get_20250917_031059/
│           ├── xss_reflected_get_20250917/
│           ├── xss_stored_20250918/
│           ├── csrf_change_secret_20250918/
│           ├── unrestricted_upload_20250918/
│           ├── insecure_dor_change_secret_20250918/
│           ├── info_disclosure_headers_20250918/
│           ├── dir_traversal_20250918/
│           └── … (other detected issues)
│
├── 3_tls/                         # SSL/TLS assessment results
├── 4_reports/                     # Final VAPT reports (Word & PDF)
├── screenshots/                   # Screenshots supporting PoCs
├── commands/                      # Helper scripts & execution logs
├── findings/                      # Consolidated vulnerability notes
├── scope.txt                      # Defined scope of the assessment
└── README.md                      # Project documentation (this file)
```

---

## 🐞 Vulnerabilities Detected (So Far)

| #  | Category                           | Vulnerability                        | Folder Reference                                        |
|----|------------------------------------|--------------------------------------|--------------------------------------------------------|
| 1  | Injection (A1)                     | SQL Injection (GET/Search)           | `sqli_get_20250917_031059/`                            |
| 2  | XSS (A3)                           | Reflected XSS (GET)                  | `xss_get_20250917_034645/`                             |
| 3  | XSS (A3)                           | Stored XSS (Blog & Change Secret)    | `xss_stored_20250918/`, `xss_change_secret_20250918/`  |
| 4  | CSRF (A8)                          | CSRF – Change Secret                 | `csrf_change_secret_20250918/`                         |
| 5  | Insecure File Upload (A5)          | Unrestricted File Upload              | `unrestricted_upload_20250918/`                        |
| 6  | Insecure Direct Object Reference   | IDOR – Change Secret                  | `insecure_dor_change_secret_20250918/`                 |
| 7  | Information Disclosure (A6)        | Server Headers & PHP Version          | `info_disclosure_headers_20250918/`                    |
| 8  | Path Traversal (A5)                | Directory Traversal (`/etc/passwd`)   | `dir_traversal_20250918/`                              |
| 9+ | More in progress…                  | Blind SQLi, Clickjacking, SSRF, etc. | Under analysis                                          |

---

## 📝 Reporting
- Each vulnerability folder contains:
  - **Raw evidence** (HTML responses, headers, curl outputs).
  - **Textual proof summary** (`proof_*.txt`) with description, impact, and remediation.
  - **Screenshots** (where applicable).
- A consolidated **final report (Word & PDF)** will be available in `/4_reports/`.

---

## 🚀 Usage
1. Clone this repo:
   ```bash
   git clone https://github.com/SAIBHAVYAE/itsecgames-vapt.git
   ```
2. Browse into `2_vulnerability_detection/proofs/detected_vulnerabilities/` for all PoCs.
3. Open `/4_reports/` for final documented deliverables.

---

## 📅 Project Timeline
- Reconnaissance & Environment Setup – ✅ Completed (Sept 17)
- Vulnerability Detection (Step 2) – 🚧 Ongoing
- Reporting & Consolidation – 📌 Target: Before Sept 21
- Video Demonstration – 🎥 Planned for final submission

---

## 🙏 Acknowledgements
- **bWAPP (Buggy Web Application)** – by Malik Mesellem (itsecgames.com).
- OWASP for methodologies and testing guides.
- Kali Linux & standard pentesting toolchain.

---

✔️ This repo is for **educational purposes only** within a controlled lab.  
Unauthorized use against systems you do not own or have permission to test is strictly prohibited.

---
