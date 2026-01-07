#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
apps_dir="$repo_root/apps"

errors=0

fail() {
  echo "ERROR: $1" >&2
  errors=$((errors + 1))
}

if [[ ! -d "$apps_dir" ]]; then
  fail "Missing apps directory: $apps_dir"
else
  shopt -s nullglob
  app_entries=("$apps_dir"/*)
  if [[ ${#app_entries[@]} -eq 0 ]]; then
    fail "No apps found in $apps_dir"
  fi

  for entry in "${app_entries[@]}"; do
    if [[ ! -d "$entry" ]]; then
      fail "Non-directory entry in apps/: $entry"
      continue
    fi

    app_id=$(basename "$entry")
    root_dir="$repo_root/$app_id"
    if [[ ! -d "$root_dir" ]]; then
      fail "Missing app directory at repo root: $root_dir (run scripts/publish.sh)"
    else
      for req in umbrel-app.yml docker-compose.yml README.md; do
        if [[ ! -f "$root_dir/$req" ]]; then
          fail "Missing $req in $root_dir (run scripts/publish.sh)"
        fi
      done
    fi

    for req in umbrel-app.yml docker-compose.yml README.md; do
      if [[ ! -f "$entry/$req" ]]; then
        fail "Missing $req in $entry"
      fi
    done
  done
fi

if [[ ! -f "$repo_root/umbrel-app-store.yml" ]]; then
  fail "Missing store metadata: $repo_root/umbrel-app-store.yml"
fi

shopt -s nullglob
yaml_files=(
  "$repo_root/umbrel-app-store.yml"
  "$repo_root/templates"/*.yml
  "$repo_root/templates"/*.yaml
  "$apps_dir"/*/*.yml
  "$apps_dir"/*/*.yaml
)

for yf in "${yaml_files[@]}"; do
  if [[ -f "$yf" && ! -s "$yf" ]]; then
    fail "Empty YAML file: $yf"
  fi
done

if command -v yamllint >/dev/null 2>&1; then
  yamllint "${yaml_files[@]}"
fi

if [[ $errors -gt 0 ]]; then
  exit 1
fi

echo "Validation OK"
