#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
apps_dir="$repo_root/apps"

errors=0
manifest_ports=()
manifest_port_apps=()
port_ranges=()
port_range_apps=()

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

    manifest_port=$(rg -m1 '^port:' "$entry/umbrel-app.yml" 2>/dev/null | sed -E 's/^port:[[:space:]]*"?([0-9]+)"?.*/\1/')
    if [[ -z "$manifest_port" ]]; then
      fail "Missing port in $entry/umbrel-app.yml"
    else
      for i in "${!manifest_ports[@]}"; do
        if [[ "${manifest_ports[$i]}" == "$manifest_port" ]]; then
          fail "Port conflict: $manifest_port used by $app_id and ${manifest_port_apps[$i]}"
        fi
      done
      manifest_ports+=("$manifest_port")
      manifest_port_apps+=("$app_id")
    fi

    app_proxy_port=$(rg -m1 '^[[:space:]]*APP_PORT:' "$entry/docker-compose.yml" 2>/dev/null | sed -E 's/.*APP_PORT:[[:space:]]*"?([0-9]+)"?.*/\1/')
    if [[ -z "$app_proxy_port" ]]; then
      fail "Missing APP_PORT in $entry/docker-compose.yml"
    fi
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

add_port_range() {
  local app_id="$1"
  local start="$2"
  local end="$3"
  local label="$4"
  local idx existing_start existing_end

  for idx in "${!port_ranges[@]}"; do
    existing_start="${port_ranges[$idx]%:*}"
    existing_end="${port_ranges[$idx]#*:}"
    if [[ "$start" -le "$existing_end" && "$end" -ge "$existing_start" ]]; then
      fail "Host port conflict: $app_id $label overlaps with ${port_range_apps[$idx]} ${port_ranges[$idx]//:/-}"
      return
    fi
  done

  port_ranges+=("$start:$end")
  port_range_apps+=("$app_id")
}

for compose in "$apps_dir"/*/docker-compose.yml; do
  [[ -f "$compose" ]] || continue
  app_id=$(basename "$(dirname "$compose")")
  while IFS= read -r line; do
    mapping=$(printf '%s' "$line" | sed -E "s/^[[:space:]]*-[[:space:]]*//; s/[\"']//g")
    host="${mapping%%:*}"
    if [[ "$host" =~ ^[0-9]+-[0-9]+$ ]]; then
      add_port_range "$app_id" "${host%-*}" "${host#*-}" "$host"
    elif [[ "$host" =~ ^[0-9]+$ ]]; then
      add_port_range "$app_id" "$host" "$host" "$host"
    fi
  done < <(rg --no-line-number -e "^[[:space:]]*-[[:space:]]*[\"']?[0-9]{2,5}(-[0-9]{2,5})?:[0-9]{2,5}(-[0-9]{2,5})?[\"']?[[:space:]]*$" "$compose" || true)
done

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
