#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
apps_dir="$repo_root/apps"

if [[ ! -d "$apps_dir" ]]; then
  echo "ERROR: Missing apps directory: $apps_dir" >&2
  exit 1
fi

shopt -s nullglob
app_entries=("$apps_dir"/*)
if [[ ${#app_entries[@]} -eq 0 ]]; then
  echo "ERROR: No apps found in $apps_dir" >&2
  exit 1
fi

for entry in "${app_entries[@]}"; do
  [[ -d "$entry" ]] || continue
  app_id=$(basename "$entry")
  root_dir="$repo_root/$app_id"

  mkdir -p "$root_dir"

  for req in umbrel-app.yml docker-compose.yml README.md; do
    if [[ ! -f "$entry/$req" ]]; then
      echo "ERROR: Missing $req in $entry" >&2
      exit 1
    fi
    cp "$entry/$req" "$root_dir/$req"
  done

  # Copy icon if it exists
  if [[ -f "$entry/icon.png" ]]; then
    cp "$entry/icon.png" "$root_dir/icon.png"
  fi

done

echo "Published apps to repo root."
