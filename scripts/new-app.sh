#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
apps_dir="$repo_root/apps"

tpl_app="$repo_root/templates/umbrel-app.yml.tpl"
tpl_compose="$repo_root/templates/docker-compose.yml.tpl"

usage() {
  echo "Usage: ./scripts/new-app.sh <app-id> \"<App Name>\"" >&2
}

escape_sed() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

app_id="$1"
app_name="$2"

if [[ ! "$app_id" =~ ^[a-z0-9-]+$ ]]; then
  echo "ERROR: app-id must be lowercase letters, numbers, and dashes." >&2
  exit 1
fi

if [[ ! -f "$tpl_app" || ! -f "$tpl_compose" ]]; then
  echo "ERROR: templates missing in $repo_root/templates" >&2
  exit 1
fi

app_dir="$apps_dir/$app_id"
if [[ -e "$app_dir" ]]; then
  echo "ERROR: app already exists: $app_dir" >&2
  exit 1
fi

mkdir -p "$app_dir"

app_id_esc=$(escape_sed "$app_id")
app_name_esc=$(escape_sed "$app_name")

sed -e "s/__APP_ID__/$app_id_esc/g" \
    -e "s/__APP_NAME__/$app_name_esc/g" \
    -e "s/__TAGLINE__/Replace this tagline/g" \
    -e "s/__ICON_URL__/REPLACE_WITH_ICON_URL/g" \
    -e "s/__CATEGORY__/Utilities/g" \
    -e "s/__VERSION__/0.1.0/g" \
    -e "s/__APP_PORT__/3000/g" \
    -e "s/__DESCRIPTION__/Replace this description/g" \
    -e "s/__DEVELOPER__/Your Name/g" \
    -e "s/__WEBSITE__/https:\/\/example.com/g" \
    -e "s/__SUBMITTER__/Your Name/g" \
    -e "s/__SUBMISSION_URL__/https:\/\/example.com/g" \
    -e "s/__REPO_URL__/https:\/\/example.com/g" \
    -e "s/__SUPPORT_URL__/https:\/\/example.com/g" \
    -e "s/__RELEASE_NOTES__/Initial release./g" \
    "$tpl_app" > "$app_dir/umbrel-app.yml"

sed -e "s/__APP_ID__/$app_id_esc/g" \
    -e "s/__APP_PORT__/3000/g" \
    -e "s/__IMAGE__/REPLACE_WITH_IMAGE/g" \
    "$tpl_compose" > "$app_dir/docker-compose.yml"

cat <<'README' > "$app_dir/README.md"
# __APP_NAME__

## Overview
Short description of the app.

## Configuration
- Ports: 3000
- Volumes: __APP_ID___data -> /data

## Notes
Replace placeholder values in `umbrel-app.yml` and `docker-compose.yml`.
README

sed -i '' \
    -e "s/__APP_ID__/$app_id_esc/g" \
    -e "s/__APP_NAME__/$app_name_esc/g" \
    "$app_dir/README.md"

echo "Created app scaffold in $app_dir"
echo "Note: umbrel-app-store.yml only defines store metadata; no app registry update needed."
