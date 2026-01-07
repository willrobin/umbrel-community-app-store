# Development

## Requirements
- git
- Optional: `yamllint`
- Optional: python3

## Local Workflow
1) Create a new app scaffold:
   `./scripts/new-app.sh <app-id> "<App Name>"`
2) Edit `apps/<app-id>/umbrel-app.yml`, `docker-compose.yml`, `README.md`.
3) Publish to repo root:
   `./scripts/publish.sh`
4) Validate:
   `./scripts/validate.sh`
5) Commit and push.

## Umbrel App Discovery
- Umbrel expects apps at repo root. We keep apps in `apps/` and publish a copy
  to the repo root via `./scripts/publish.sh`.

## Git Hooks (auto commit messages)
- Enable once per clone:
  `./scripts/setup-githooks.sh`

## Umbrel Store Metadata
- `umbrel-app-store.yml` describes the store itself. It does not list apps.
