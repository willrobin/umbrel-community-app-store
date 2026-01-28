# CLAUDE.md — Persistent Context for Claude Code

> This file is read automatically at the start of every Claude Code session.
> It defines what this project is, how we work, and what to check every time.

## Project Purpose

This is the **Kasa Umbrel Community App Store** — a collection of Docker containers
packaged specifically for **umbrelOS**. Every app we add must conform to Umbrel's
app packaging format and conventions. This is not a generic Docker Compose project.

**Always remember:** We are building Docker containers for umbrelOS, not for standalone
Docker deployment. Umbrel has its own proxy, environment variables, discovery mechanism,
and app manifest format. Every decision must account for this.

---

## Repository Structure (Two-Directory Pattern)

```
repo-root/
├── apps/                    # SOURCE — All edits happen here
│   └── kasa-<app-id>/
│       ├── umbrel-app.yml   # App manifest (metadata, ports, description)
│       ├── docker-compose.yml
│       ├── README.md
│       └── icon.png         # App icon (PNG, stays in apps/ only)
│
├── kasa-<app-id>/           # PUBLISHED — Umbrel reads from here
│   ├── umbrel-app.yml       # ← Copied by publish.sh
│   ├── docker-compose.yml   # ← Copied by publish.sh
│   └── README.md            # ← Copied by publish.sh
│
├── scripts/
│   ├── new-app.sh           # Scaffold a new app
│   ├── publish.sh           # Sync apps/ → root level
│   └── validate.sh          # Validate all configs
│
├── templates/               # Templates for new-app.sh
├── docs/                    # Detailed guides (checklist, architecture)
├── umbrel-app-store.yml     # Store metadata (id: kasa, name: Kasa)
├── README.md                # Main README with app table
├── CLAUDE.md                # This file
├── AGENTS.md                # AI contributor rules
├── CONTRIBUTING.md          # Contribution guidelines
└── DEVELOPMENT.md           # Development workflow
```

### Golden Rules

1. **Edit files in `apps/<app-id>/` ONLY** — Never edit root-level app directories
2. **Run `./scripts/publish.sh` after EVERY change** — Syncs to root level
3. **Run `./scripts/validate.sh` before committing** — Catches errors early
4. **Root-level app directories are build artifacts** — Never manually edit or delete them

---

## Systematic Checklist: Adding or Updating an App

When adding a new app or updating an existing one, work through these steps **in order**.
Do not skip steps. Mark each as done before proceeding.

### Phase 1: Research & Preparation

- [ ] **Understand the upstream project** — Read the official docs, check the Docker
  image availability, supported architectures (AMD64/ARM64), and required services
  (databases, caches, etc.)
- [ ] **Choose the right Docker image** — Prefer official multi-arch images. Check with
  `docker manifest inspect <image>:<tag>`. Document if single-arch only.
- [ ] **Pin the image version** — Use specific tags (e.g., `v6.1.0`), not `:latest`.
  Prefer SHA256 manifest list digests when possible.
- [ ] **Identify all required ports** — Check what ports the app needs and verify no
  conflicts with existing apps in the store (see Port Allocation below).
- [ ] **Identify dependencies** — Does the app need a database (Postgres, MySQL, Redis)?
  Does it depend on another Umbrel app (e.g., Paperless-ngx)?

### Phase 2: Scaffold & Implement

- [ ] **Create the app scaffold** — `./scripts/new-app.sh kasa-<name> "<Display Name>"`
- [ ] **Prepare the icon** — Source a high-quality PNG icon (ideally 256×256 or larger,
  square). Place it at `apps/kasa-<name>/icon.png`.
- [ ] **Configure `umbrel-app.yml`** — Fill in ALL fields completely:
  - `id`: Must match folder name exactly (`kasa-<name>`)
  - `name`: Correctly spelled display name
  - `tagline`: Concise one-liner (max ~80 chars)
  - `icon`: GitHub raw URL pointing to `apps/kasa-<name>/icon.png`
  - `category`: One of `Media`, `Productivity`, `Automation`, `Utilities`, etc.
  - `version`: Semantic version matching the Docker image
  - `port`: Unique port number (check Port Allocation)
  - `description`: Detailed multi-paragraph description (use `>-` YAML folding)
  - `developer`: Original upstream developer/organization
  - `website`: Official project website
  - `submitter`: `Kasa`
  - `submission`: `https://github.com/willrobin/umbrel-community-app-store`
  - `repo`: Upstream repository URL
  - `support`: Issues URL
  - `gallery`: Array of screenshot URLs (use upstream project screenshots)
  - `releaseNotes`: Meaningful release notes for this version
  - `dependencies`: Array of dependent Umbrel app IDs (usually `[]`)
  - `path`, `defaultUsername`, `defaultPassword`: Set if applicable

- [ ] **Configure `docker-compose.yml`** — Follow Umbrel conventions:
  - Use `version: "3.7"`
  - Include `app_proxy` service with `APP_HOST` and `APP_PORT`
  - `APP_HOST` format: `<app-id>_<service-name>_1` (or service name if using `container_name`)
  - Use `init: true` for proper signal handling
  - Use `restart: unless-stopped`
  - Use `user: "1000:1000"` where possible (non-root)
  - Use `${APP_DATA_DIR}` for persistent data volumes
  - Use `${APP_PASSWORD}` and `${APP_SEED}` for secrets
  - Use `${DEVICE_DOMAIN_NAME}` for URLs that need the host
  - Add `depends_on` with `condition: service_healthy` for databases
  - Add health checks with appropriate `start_period` and `retries`
  - Use `stop_grace_period` for services that need graceful shutdown
  - Only expose host `ports:` when absolutely necessary (streaming, discovery)
  - Add `cap_drop: ALL` and `security_opt: no-new-privileges` where possible

- [ ] **Write the app README** — Include these sections:
  1. Title and overview
  2. Architecture requirements (AMD64/ARM64 table if relevant)
  3. Features list
  4. Links (website, docs, repo, issues)
  5. Configuration table (ports, volumes, env vars)
  6. Getting started steps
  7. Notes/important information
  8. Troubleshooting section

- [ ] **Add screenshots to gallery** — Find official screenshots from the upstream
  project. Add their URLs to the `gallery:` array in `umbrel-app.yml`.

### Phase 3: Quality Checks

- [ ] **Icon check** — Verify `icon.png` exists in `apps/kasa-<name>/` and the
  `icon:` URL in `umbrel-app.yml` points to it correctly
- [ ] **Name check** — Verify the app name is correctly spelled in `umbrel-app.yml`,
  `docker-compose.yml`, and `README.md`
- [ ] **Description check** — Verify `tagline` and `description` are meaningful,
  accurate, and well-written
- [ ] **Version & changelog check** — Verify `version` matches the Docker image tag
  and `releaseNotes` describe what changed
- [ ] **Port uniqueness check** — Verify the port doesn't conflict with existing apps
- [ ] **Screenshot check** — Verify gallery URLs are valid and accessible

### Phase 4: Publish & Validate

- [ ] **Run `./scripts/publish.sh`** — Copies files to root level
- [ ] **Run `./scripts/validate.sh`** — Validates all configurations
- [ ] **Verify root-level directory** — Check that `kasa-<name>/` at root has the
  correct files synced

### Phase 5: Update Repository Documentation

- [ ] **Update `README.md`** — Add the new app to the "Available Apps" table with:
  - Sequential number
  - Icon reference: `<img height="28" src="apps/kasa-<name>/icon.png" />`
  - App name with link: `[App Name](apps/kasa-<name>)`
  - Short description
  - Port number
- [ ] **Update Port Allocation table** in `README.md` if new ports are used
- [ ] **Update App Dependencies** section in `README.md` if applicable

### Phase 6: Commit & PR

- [ ] **Stage specific files** — Add only relevant files, never use `git add -A`
- [ ] **Write descriptive commit message** — Format: `feat(kasa-<name>): add <App Name> as Umbrel app`
- [ ] **Create PR with meaningful description** — Include summary, what the app does,
  and a test plan

---

## Umbrel Environment Variables Reference

These variables are automatically provided by umbrelOS at runtime:

| Variable | Purpose | Usage |
|----------|---------|-------|
| `${APP_DATA_DIR}` | App-specific data directory | Volume mounts for persistence |
| `${APP_PASSWORD}` | Auto-generated password | Database credentials |
| `${APP_SEED}` | Secure random seed | Encryption keys, secrets |
| `${DEVICE_DOMAIN_NAME}` | Device hostname (e.g., `umbrel.local`) | Public-facing URLs |
| `${DEVICE_HOSTNAME}` | Short hostname | Internal references |
| `${UMBREL_ROOT}` | Umbrel root path | Access shared directories |
| `${TOR_PROXY_IP}` | Tor proxy IP | Tor-enabled apps |
| `${TOR_PROXY_PORT}` | Tor proxy port | Tor-enabled apps |
| `${APP_HIDDEN_SERVICE}` | Tor onion address | Tor-enabled apps |
| `${APP_BITCOIN_NODE_IP}` | Bitcoin node IP | Bitcoin-dependent apps |
| `${APP_BITCOIN_RPC_PORT}` | Bitcoin RPC port | Bitcoin-dependent apps |
| `${APP_BITCOIN_RPC_USER}` | Bitcoin RPC user | Bitcoin-dependent apps |
| `${APP_BITCOIN_RPC_PASS}` | Bitcoin RPC password | Bitcoin-dependent apps |

---

## Port Allocation

Keep this table current. Every app must have a unique port.

| Port | App |
|------|-----|
| 3001 | Paperless-AI |
| 3002 | Cal.com |
| 3003 | Paperless-GPT |
| 3004 | AzuraCast Web UI |
| 3005 | Music Assistant |
| 3006 | Music Assistant Streams |
| 3007 | Moltbot Gateway |
| 8000–8010 | AzuraCast Streaming |

Next available port: **3008**

---

## Docker-Compose Patterns for Umbrel

### Minimal App (single service)

```yaml
version: "3.7"

services:
  app_proxy:
    environment:
      APP_HOST: kasa-<name>_server_1
      APP_PORT: 3000

  server:
    image: <image>:<tag>
    user: "1000:1000"
    init: true
    restart: unless-stopped
    volumes:
      - ${APP_DATA_DIR}/data:/data
```

### App with Database

```yaml
version: "3.7"

services:
  app_proxy:
    environment:
      APP_HOST: <service-name>
      APP_PORT: 3000

  app:
    image: <image>:<tag>
    init: true
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    environment:
      DATABASE_URL: "postgresql://user:${APP_PASSWORD}@db:5432/dbname"

  db:
    image: postgres:15-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: "dbname"
      POSTGRES_USER: "user"
      POSTGRES_PASSWORD: "${APP_PASSWORD}"
    volumes:
      - ${APP_DATA_DIR}/db:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d dbname"]
      interval: 10s
      timeout: 5s
      retries: 15
      start_period: 60s
```

---

## Widgets for umbrelOS

As of January 2026, umbrelOS dashboard widgets are **not available for community
app stores**. Widget functionality is currently restricted to the official Umbrel
app store and internal Umbrel development. Monitor Umbrel's official documentation
and GitHub for updates on community widget support. When widget support becomes
available, this section should be updated with implementation guidelines.

---

## Commit Message Convention

```
type(scope): short summary

feat(kasa-<name>):  add <App Name> as Umbrel app
fix(kasa-<name>):   resolve <specific issue>
docs:               update README with new app listing
chore(apps):        update <App Name> to v<x.y.z>
refactor(kasa-<name>): improve docker-compose configuration
```

---

## Reminders for Every Session

1. **We are building for umbrelOS** — Not generic Docker. Always use Umbrel conventions.
2. **README must stay current** — Every app change must be reflected in the main README.
3. **Descriptions matter** — Write meaningful taglines, descriptions, and release notes.
4. **Icons at every touchpoint** — Verify icon.png exists and URL is correct.
5. **Versions and changelogs** — Always update `version` and `releaseNotes` together.
6. **Screenshots when available** — Check upstream projects for gallery images.
7. **Publish and validate** — Always run both scripts before committing.
8. **Port conflicts** — Check the allocation table before assigning ports.
9. **Security first** — Non-root containers, no secrets in repo, minimal privileges.
10. **Documentation is not optional** — Every app needs a complete README with all sections.
