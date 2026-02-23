#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

forgejo_url="${1:-ssh://git@umbrel.local:2223/robinwill/umbrel-community-app-store.git}"
github_fetch_url="${2:-https://github.com/willrobin/umbrel-community-app-store.git}"
github_push_url="${3:-git@github.com:willrobin/umbrel-community-app-store.git}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: This script must be run inside a git repository." >&2
  exit 1
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$forgejo_url"
else
  git remote add origin "$forgejo_url"
fi

# origin fetches from Forgejo and pushes to both Forgejo + GitHub.
while IFS= read -r existing_push; do
  [[ -n "$existing_push" ]] || continue
  git remote set-url --delete --push origin "$existing_push" || true
done < <(git remote get-url --push --all origin 2>/dev/null || true)
git remote set-url --add --push origin "$forgejo_url"
git remote set-url --add --push origin "$github_push_url"

# Dedicated GitHub remote for explicit fetch/compare operations.
if git remote get-url github >/dev/null 2>&1; then
  git remote set-url github "$github_fetch_url"
else
  git remote add github "$github_fetch_url"
fi
git remote set-url --push github "$github_push_url"

echo "Remote setup complete."
git remote -v
