#!/usr/bin/env bash
# sync_step2_evidence.sh
# One-time sync of Step 2 evidence into itsecgames-vapt repo

set -euo pipefail
IFS=$'\n\t'

# ========== CONFIGURE THESE ==========

# Path where shared/Kali proofs folder is synced on Windows
# Change this to match your actual path
PROOFS_SOURCE_PATH="$HOME/OneDrive/Documents/BB/ITSecGames/itsecgames.com/proofs"

# Local Git repo root (where .git lives)
REPO_PATH="$HOME/OneDrive/Documents/BB/ITSecGames/itsecgames-vapt"

# Branch to commit and push to (e.g. main or proof-step2)
TARGET_BRANCH="main"

# Commit message prefix
COMMIT_MSG_PREFIX="Step2 evidence: detected vulnerabilities and environment"

# ======================================

echo "📍 Repo path: ${REPO_PATH}"
echo "📂 Proofs source path: ${PROOFS_SOURCE_PATH}"

if [ ! -d "${REPO_PATH}/.git" ]; then
    echo "ERROR: No git repo at ${REPO_PATH}"
    exit 1
fi
if [ ! -d "${PROOFS_SOURCE_PATH}" ]; then
    echo "ERROR: Proofs source folder not found: ${PROOFS_SOURCE_PATH}"
    exit 2
fi

cd "${REOPOATH:?Error with REPO_PATH}"  # This has a typo, fix it
# Oops, I spotted a typo, let's correct the script below

