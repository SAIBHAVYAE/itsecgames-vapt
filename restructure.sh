#!/bin/bash
# === Repo Cleanup Script ===
# Run this inside: itsecgames.com repo root

set -e

echo "[1/5] Removing helper scripts from proofs..."
find 2_vulnerability_detection/proofs/detected_vulnerabilities -type f -name "detect-more.sh" -delete

echo "[2/5] Moving any stray scripts to 5_scripts/"
mkdir -p 5_scripts
find 2_vulnerability_detection/proofs/detected_vulnerabilities -type f -name "*.sh" -exec mv -v {} 5_scripts/ \;

echo "[3/5] Deleting empty placeholder files (0-byte)"
find 2_vulnerability_detection/proofs/detected_vulnerabilities -type f -size 0 -exec rm -v {} \;

echo "[4/5] Normalizing folder names (dir_trav_quick → dir_traversal_<date>)"
for d in 2_vulnerability_detection/proofs/detected_vulnerabilities/dir_trav_quick*; do
  if [ -d "$d" ]; then
    ts=$(date -u +%Y%m%d_%H%M%S)
    mv -v "$d" "2_vulnerability_detection/proofs/detected_vulnerabilities/dir_traversal_${ts}"
  fi
done

echo "[5/5] Git stage & commit"
git add -A
git commit -m "Cleanup: remove helper scripts, delete empty files, normalize vuln proof folders [$(date -u +%Y%m%d)]" || echo "No changes to commit"
git push origin main

echo "✅ Cleanup complete! Repo is now polished."

