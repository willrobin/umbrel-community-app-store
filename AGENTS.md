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
│       └── icon.png         # Icons stay in apps/ only
│
├── kasa-app/                # PUBLISHED: Umbrel reads from here
│   ├── umbrel-app.yml       # ← Copied by publish.sh
│   ├── docker-compose.yml   # ← Copied by publish.sh
│   └── README.md            # ← Copied by publish.sh
│
├── scripts/
│   └── publish.sh           # Copies apps/* → root/*
└── umbrel-app-store.yml
```

**Why this structure?**
- Umbrel discovers apps from the **repository root**, not from subdirectories
- We keep source files in `apps/` for organization and to include extras (icon.png)
- `publish.sh` copies only the 3 required files to root level

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
1) Scaffold: `./scripts/new-app.sh <app-id> "<App Name>"`
2) Edit app files and README.
3) Publish: `./scripts/publish.sh`
4) Validate: `./scripts/validate.sh`
5) Commit with message style: `type(scope): short summary` (example: `chore(apps): add foo`).

## PR / Commit Guidelines
- Keep commits small and reviewable.
- One logical change per commit.
- Explain migrations or breaking changes in the commit message body.

## Security Checklist (short)
- Use non-root containers where possible.
- Avoid exposing unnecessary ports.
- Persist only required data via volumes.
- Do not store secrets in repo or compose files.

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
