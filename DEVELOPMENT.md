# Development

## Requirements
- git
- Optional: `yamllint`
- Optional: python3

## Local Workflow
1) Create a new app scaffold:
   `./scripts/new-app.sh <app-id> "<App Name>"`
2) Edit `apps/<app-id>/umbrel-app.yml`, `docker-compose.yml`, `README.md`.
3) Validate:
   `./scripts/validate.sh`
4) Commit and push.

## Git Hooks (auto commit messages)
- Enable once per clone:
  `./scripts/setup-githooks.sh`

## Umbrel Store Metadata
- `umbrel-app-store.yml` describes the store itself. It does not list apps.
