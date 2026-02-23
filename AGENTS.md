# Agent Guidelines

These rules apply to Codex/Claude Code contributors working in this repo.

## CRITICAL: Repository Structure

**DO NOT DELETE root-level app directories (e.g., `kasa-azuracast/`)!**

This repository uses a two-directory pattern required by Umbrel:

```
repo-root/
├── apps/                    # SOURCE: Development happens here
│   └── kasa-app/
│       ├── umbrel-app.yml
│       ├── docker-compose.yml
│       ├── README.md
│       └── icon.png         # Source icon (canonical)
│
├── kasa-app/                # PUBLISHED: Umbrel reads from here
│   ├── umbrel-app.yml       # ← Copied by publish.sh
│   ├── docker-compose.yml   # ← Copied by publish.sh
│   ├── README.md            # ← Copied by publish.sh
│   └── icon.png             # ← Copied by publish.sh (if present)
│
├── scripts/
│   ├── publish.sh           # Copies apps/* → root/*
│   ├── validate.sh          # Validates manifests/compose/safety checks
│   └── setup-remotes.sh     # Configures Forgejo+GitHub sync remotes
└── umbrel-app-store.yml
```

**Why this structure?**
- Umbrel discovers apps from the **repository root**, not from subdirectories
- We keep source files in `apps/` for organization
- `publish.sh` copies required app files (and `icon.png` when present) to root level

**Golden Rules:**
1. Edit files in `apps/<app-id>/` ONLY
2. Run `./scripts/publish.sh` after EVERY change
3. NEVER manually edit or delete root-level app directories
4. Root directories are auto-generated - treat them as build artifacts

## Conventions
- Apps live in `apps/<app-id>/`.
- Required per app: `umbrel-app.yml`, `docker-compose.yml`, `README.md`.
- Templates live in `templates/` and should be kept minimal.
- Scripts live in `scripts/` and must be portable (macOS bash).
- Prefer Umbrel-provided env vars for paths and hostnames (see below).

## Do / Don't
- Do keep changes small, scoped, and well-explained.
- Do update docs when behavior or structure changes.
- Don't add secrets or real credentials.
- Don't run unconfirmed destructive commands.
- Don't introduce breaking changes without calling them out.

## Workflow
1) One-time remote setup: `./scripts/setup-remotes.sh`
2) Scaffold: `./scripts/new-app.sh <app-id> "<App Name>"`
3) Edit app files and README.
4) Publish: `./scripts/publish.sh`
5) Validate: `./scripts/validate.sh`
6) Commit with message style: `type(scope): short summary` (example: `chore(apps): add foo`).
7) Push once: `git push origin <branch>` (pushes to Forgejo + GitHub).

## PR / Commit Guidelines
- Keep commits small and reviewable.
- One logical change per commit.
- Explain migrations or breaking changes in the commit message body.

## Security Checklist (short)
- Use non-root containers where possible.
- Avoid exposing unnecessary ports.
- Persist only required data via volumes.
- Do not store secrets in repo or compose files.
- Use placeholders or Umbrel env vars (`APP_PASSWORD`, `APP_SEED`) for sensitive values.
- Keep remote URLs credential-free (SSH URLs preferred for push).

## Umbrel Env Vars (umbrelOS 1.5 docs + verified)
- Paths: `APP_DATA_DIR`, `APP_BITCOIN_DATA_DIR`, `APP_LIGHTNING_NODE_DATA_DIR`.
- Root path: `UMBREL_ROOT` (optional; prefer `APP_DATA_DIR` in app compose files).
- Host/device: `DEVICE_HOSTNAME`, `DEVICE_DOMAIN_NAME`.
- App secrets: `APP_PASSWORD`, `APP_SEED`.
- Tor: `TOR_PROXY_IP`, `TOR_PROXY_PORT`, `APP_HIDDEN_SERVICE`.
- Bitcoin RPC (if app depends on Bitcoin): `APP_BITCOIN_NODE_IP`, `APP_BITCOIN_RPC_PORT`, `APP_BITCOIN_RPC_USER`, `APP_BITCOIN_RPC_PASS`.

## Ports (Umbrel apps)
- Keep `umbrel-app.yml` ports unique across apps and in the typical Umbrel range where possible.
- Prefer `app_proxy` and avoid host `ports:` unless the app needs extra endpoints (streaming, etc.).
- Document any exposed host ports in the app README.

## app_proxy Convention (required)
- `APP_HOST` must use: `<app-id>_<service-name>_1` (official Umbrel format).
- `APP_PORT` must match the target service's container port.
- If `network_mode: host` is used, document why and ensure the manifest `port` is reachable.

## Git Remotes: Forgejo + GitHub
- Primary fetch remote: `origin` (Forgejo at `umbrel.local`).
- `origin` has two push URLs: Forgejo + GitHub.
- Additional `github` remote exists for explicit fetch/compare.
- Setup script: `./scripts/setup-remotes.sh`
- Detailed guide: `docs/git-remote-sync.md`

### Quick checks
- `git remote -v`
- `git fetch --all --prune`
- `git rev-list --left-right --count HEAD...origin/main`
- `git rev-list --left-right --count HEAD...github/main`
