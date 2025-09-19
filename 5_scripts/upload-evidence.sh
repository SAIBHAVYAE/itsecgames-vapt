

#!/usr/bin/env bash
# update_repo.sh
# Cleans local proof folders for grader-friendly layout, commits, and pushes to origin.
# Intended to run from repo root in Git Bash on Windows.
# Safety: script does checks and reports what it will do.

set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(pwd)"
TS="$(date +%Y%m%d_%H%M%S)"
COMMIT_MSG="proofs: tidy detected_vulnerabilities and environment evidence - ${TS}"

echo "Repo root: ${REPO_ROOT}"
# quick sanity: ensure we're in a git repo
if [ ! -d ".git" ]; then
  echo "ERROR: .git not found in ${REPO_ROOT}. Run this from the repository root."
  exit 2
fi

# paths (relative to repo root)
PROOFS_DIR="proofs"
DETECTED_DIR="${PROOFS_DIR}/detected_vulnerabilities"
STEP2_PATH="${PROOFS_DIR}/step2"   # in case some remnants exist
ENV_DIR="${PROOFS_DIR}/environment"

# 1) Ensure base dirs exist
mkdir -p "${DETECTED_DIR}"
mkdir -p "${ENV_DIR}"

echo
echo "Current contents of ${DETECTED_DIR}:"
ls -1 "${DETECTED_DIR}" || echo "<empty>"

echo
echo "Planned actions (will execute):"
echo " - Move any environment_* folders from ${DETECTED_DIR} -> ${ENV_DIR}"
echo " - Remove redundant folder: xss_stored_20250917_040129 (if present)"
echo " - Ensure only desired vuln folders remain in ${DETECTED_DIR}"
echo " - Remove leftover ${STEP2_PATH} if exists"
echo " - git add -A, commit and push to origin (branch: current branch)"
echo

read -p "Type YES to proceed with these actions: " CONFIRM
if [ "${CONFIRM}" != "YES" ]; then
  echo "Aborted by user. No changes made."
  exit 0
fi

# 2) Move environment_* directories from detected_vulnerabilities to proofs/environment
shopt -s nullglob
for d in "${DETECTED_DIR}"/environment_*; do
  if [ -d "${d}" ]; then
    echo "Moving $(basename "${d}") -> ${ENV_DIR}/"
    mv -v "${d}" "${ENV_DIR}/"
  fi
done
shopt -u nullglob

# 3) Remove redundant stored XSS folder if found
REDUNDANT="${DETECTED_DIR}/xss_stored_20250917_040129"
if [ -d "${REDUNDANT}" ]; then
  echo "Removing redundant folder: ${REDUNDANT}"
  rm -rf "${REDUNDANT}"
else
  echo "Redundant folder not present: ${REDUNDANT} (OK)"
fi

# 4) Optional: If there is a leftover proofs/step2 directory on Windows, remove it
if [ -d "${STEP2_PATH}" ]; then
  echo "Removing leftover folder: ${STEP2_PATH}"
  rm -rf "${STEP2_PATH}"
fi

echo
echo "Post-cleanup contents:"
echo " - ${PROOFS_DIR}/"
ls -la "${PROOFS_DIR}" || true
echo
echo " - ${DETECTED_DIR}/"
ls -la "${DETECTED_DIR}" || true
echo
echo " - ${ENV_DIR}/"
ls -la "${ENV_DIR}" || true

# 5) Git add / commit / push
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo
echo "Current git branch: ${CURRENT_BRANCH}"
git status --porcelain

echo "Staging all changes..."
git add -A

if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  echo "Committing changes: ${COMMIT_MSG}"
  git commit -m "${COMMIT_MSG}"
fi

# ensure remote exists
if git remote get-url origin >/dev/null 2>&1; then
  echo "Pushing to origin/${CURRENT_BRANCH}..."
  git push origin "${CURRENT_BRANCH}"
  echo "Push complete."
else
  echo "No 'origin' remote configured. Skipping push. (You can push manually later.)"
fi

echo
echo "Done. If you want, run 'git log -1' to confirm the commit."

