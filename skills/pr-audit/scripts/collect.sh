#!/usr/bin/env bash
# Prints what a PR audit needs to start: base, changed files, size, tests touched.
# Usage: scripts/collect.sh [base]   (default: origin/main)
set -euo pipefail

base="${1:-origin/main}"
git rev-parse --verify --quiet "$base" >/dev/null || { echo "Base '$base' not found. Fetch it or pass another base." >&2; exit 1; }
mb="$(git merge-base "$base" HEAD)"

echo "## Base"
echo "$base at $(git rev-parse --short "$mb"), head $(git rev-parse --short HEAD) on $(git branch --show-current)"
echo
echo "## Commits"
git log --oneline "$mb"..HEAD
echo
echo "## Changed files"
git diff --stat=120 "$mb"...HEAD
echo
echo "## Size"
git diff --shortstat "$mb"...HEAD
echo
echo "## Tests touched"
git diff --name-only "$mb"...HEAD | grep -Ei '(^|/)(tests?|__tests__|spec)/|\.(test|spec)\.' || echo "None. Check whether the change needs one."
echo
echo "## Risky paths"
git diff --name-only "$mb"...HEAD | grep -Ei 'auth|login|session|payment|billing|migration|delete|permission|secret|\.env|docker|workflow' || echo "None by name."
