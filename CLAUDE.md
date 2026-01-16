# CLAUDE.md

This file provides guidance for Claude Code when working with the Kasa Umbrel Community App Store.

## Project Overview

Kasa (傘) is an independent community app store for Umbrel, a home server operating system. The store provides additional apps not found in the official Umbrel app store.

## Directory Structure

```
/
├── apps/                    # App source directories
│   └── kasa-<app-id>/       # Each app in its own folder
│       ├── umbrel-app.yml   # App manifest (required)
│       ├── docker-compose.yml # Container config (required)
│       ├── README.md        # App documentation (required)
│       └── icon.png         # App icon (optional)
├── kasa-<app-id>/           # Published apps (copied to root by publish.sh)
├── scripts/                 # Development scripts
│   ├── new-app.sh           # Scaffold a new app
│   ├── publish.sh           # Copy apps to repo root for Umbrel discovery
│   ├── validate.sh          # Validate app manifests
│   └── setup-githooks.sh    # Enable git hooks
├── templates/               # Templates for new apps
├── docs/                    # Additional documentation
├── umbrel-app-store.yml     # Store metadata
├── AGENTS.md                # Agent contributor guidelines
├── CONTRIBUTING.md          # Contribution guidelines
└── DEVELOPMENT.md           # Development workflow
```

## Development Workflow

1. **Create new app**: `./scripts/new-app.sh <app-id> "<App Name>"`
2. **Edit files**: Modify `apps/<app-id>/umbrel-app.yml`, `docker-compose.yml`, `README.md`
3. **Publish**: `./scripts/publish.sh` (copies apps to repo root)
4. **Validate**: `./scripts/validate.sh` (checks manifests)
5. **Commit and push**

## App Naming Convention

- App IDs: lowercase letters, numbers, and dashes only (e.g., `my-app`)
- App folder name must match app ID
- Prefix all apps with `kasa-` (e.g., `kasa-azuracast`)

## Required App Files

Each app in `apps/<app-id>/` must have:
- `umbrel-app.yml` - App manifest with metadata
- `docker-compose.yml` - Container configuration
- `README.md` - User documentation

## Umbrel Environment Variables

Available in docker-compose.yml:
- **Paths**: `APP_DATA_DIR`, `APP_BITCOIN_DATA_DIR`, `APP_LIGHTNING_NODE_DATA_DIR`
- **Host**: `DEVICE_HOSTNAME`, `DEVICE_DOMAIN_NAME`
- **Secrets**: `APP_PASSWORD`, `APP_SEED`
- **Tor**: `TOR_PROXY_IP`, `TOR_PROXY_PORT`, `APP_HIDDEN_SERVICE`
- **Bitcoin**: `APP_BITCOIN_NODE_IP`, `APP_BITCOIN_RPC_PORT`, `APP_BITCOIN_RPC_USER`, `APP_BITCOIN_RPC_PASS`

## Port Allocation

Kasa apps use UI ports 3001-3005:
- 3001: Paperless-AI
- 3002: Cal.com
- 3003: Paperless-GPT
- 3004: AzuraCast
- 3005: Music Assistant

Additional ports for specific apps are documented in README.md.

## Commit Message Style

Use conventional commits: `type(scope): short summary`

Examples:
- `feat(apps): add new-app-name`
- `fix(kasa-azuracast): correct port mapping`
- `docs(README): update app list`
- `chore(scripts): improve validation`

## Key Guidelines

- Keep changes small and well-scoped
- Never commit secrets or credentials
- Use non-root containers where possible
- Prefer `app_proxy` over host `ports:` when possible
- Persist only necessary data via volumes
- Update docs when behavior changes
- Scripts must be portable (macOS/Linux bash compatible)

## Validation

Run `./scripts/validate.sh` before committing to check:
- Required files exist
- YAML syntax is valid
- App IDs match folder names

## References

- See `AGENTS.md` for detailed agent guidelines
- See `CONTRIBUTING.md` for contribution rules
- See `DEVELOPMENT.md` for local development setup
