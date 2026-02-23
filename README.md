# Kasa Umbrel Community App Store

Kasa (傘) means "umbrella" in Japanese, a nod to Umbrel's umbrella logo. This is an independent community app store and is not affiliated with the official Umbrel team.

## Available Apps

| # | Icon | App | Description | Port |
| :-: | :-: | :-- | :-- | :-: |
| 1 | <img height="28" src="apps/kasa-azuracast/icon.png" /> | [AzuraCast](apps/kasa-azuracast) | Self-hosted radio streaming and station management | 3004 |
| 2 | <img height="28" src="apps/kasa-calcom/icon.png" /> | [Cal.com](apps/kasa-calcom) | Open-source scheduling for teams and individuals | 3002 |
| 3 | <img height="28" src="apps/kasa-music-assistant/icon.png" /> | [Music Assistant](apps/kasa-music-assistant) | Unified music streaming for local and online sources | 3005 |
| 4 | <img height="28" src="apps/kasa-paperless-ai/icon.png" /> | [Paperless-AI](apps/kasa-paperless-ai) | AI tagging and RAG search for Paperless-ngx | 3001 |
| 5 | <img height="28" src="apps/kasa-paperless-gpt/icon.png" /> | [Paperless-GPT](apps/kasa-paperless-gpt) | LLM-powered OCR and tagging for Paperless-ngx | 3003 |
| 6 | <img height="28" src="apps/kasa-compose-patcher/icon.png" /> | [Compose Patcher](apps/kasa-compose-patcher) | Auto-repatch Docker-Compose files after Umbrel app updates | 3008 |

## App Dependencies

- **Paperless-AI** and **Paperless-GPT** require a running Paperless-ngx instance
- AI features require an LLM provider (e.g., Ollama or OpenAI). See individual app READMEs for details
- **Compose Patcher** requires a host-level daemon installed via SSH (see [host/README.md](host/README.md))

## Installation

1. Open Umbrel UI → App Store → Community App Stores
2. Add this repository URL: `https://github.com/willrobin/umbrel-community-app-store`
3. Install apps as usual from the Kasa section

![Add Community App Store Demo](https://user-images.githubusercontent.com/10330103/197889452-e5cd7e96-3233-4a09-b475-94b754adc7a3.mp4)

## Port Allocation

| Port | App |
|------|-----|
| 3001 | Paperless-AI |
| 3002 | Cal.com |
| 3003 | Paperless-GPT |
| 3004 | AzuraCast Web UI |
| 3005 | Music Assistant (Webserver) |
| 3006 | Music Assistant (Streams) |
| 3008 | Compose Patcher |
| 8000–8010 | AzuraCast Streaming |

No port conflicts with other known community app stores (verified as of January 2026).

## Data Storage

- All app data is stored under `${APP_DATA_DIR}` (set by Umbrel per app)
- Data persists across updates and reinstalls
- Backup your Umbrel data directory to preserve app configurations

## Development

### Creating a New App

```bash
./scripts/new-app.sh <app-id> "<App Name>"
```

### Workflow

1. One-time remote setup: `./scripts/setup-remotes.sh`
2. Sync remotes: `git fetch --all --prune`
3. Create app scaffold: `./scripts/new-app.sh kasa-myapp "My App"`
4. Edit files in `apps/kasa-myapp/`
5. Publish to root: `./scripts/publish.sh`
6. Validate configs: `./scripts/validate.sh`
7. Commit and push: `git push origin <branch>`

### Scripts

| Script | Purpose |
|--------|---------|
| `scripts/new-app.sh` | Create new app scaffold |
| `scripts/publish.sh` | Sync apps to root level |
| `scripts/validate.sh` | Validate YAML configurations |
| `scripts/setup-remotes.sh` | Configure Forgejo+GitHub remote sync |

## Git Sync (Forgejo + GitHub)

- `origin` fetches from Forgejo and pushes to Forgejo + GitHub
- `github` is available for explicit compare/fetch checks
- Setup and workflow details: [`docs/git-remote-sync.md`](docs/git-remote-sync.md)

Quick check:

```bash
git remote -v
git rev-list --left-right --count HEAD...origin/main
git rev-list --left-right --count HEAD...github/main
```

## Contributing

- App ideas and issues are welcome via GitHub Issues
- Never commit secrets or API keys to the repository
- Follow the [contribution guidelines](CONTRIBUTING.md)
- See [development documentation](DEVELOPMENT.md) for detailed workflow

## License

This community app store is provided as-is. Individual apps retain their original licenses.
