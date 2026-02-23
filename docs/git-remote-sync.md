# Git Remote Sync (Forgejo + GitHub)

This repository uses a dual-remote push strategy:

- `origin` fetches from **Forgejo** (`umbrel.local`)
- `origin` pushes to **Forgejo and GitHub** in one command
- `github` is an explicit remote for fetch/compare against GitHub

## Why this setup

- Forgejo stays the local/self-hosted primary endpoint
- GitHub stays in sync for public distribution
- Contributors only need one push command (`git push origin <branch>`)

## One-time setup

Run:

```bash
./scripts/setup-remotes.sh
```

Defaults:

- Forgejo fetch/push URL:
  `ssh://git@umbrel.local:2223/robinwill/umbrel-community-app-store.git`
- GitHub fetch URL:
  `https://github.com/willrobin/umbrel-community-app-store.git`
- GitHub push URL:
  `git@github.com:willrobin/umbrel-community-app-store.git`

You can override all three URLs:

```bash
./scripts/setup-remotes.sh <forgejo-url> <github-fetch-url> <github-push-url>
```

## Daily workflow

1. Fetch everything:

```bash
git fetch --all --prune
```

2. Check divergence:

```bash
git rev-list --left-right --count HEAD...origin/main
git rev-list --left-right --count HEAD...github/main
```

3. Push once to sync both remotes:

```bash
git push origin main
```

## Failure handling

Multi-remote push is not atomic.
If one target fails, push it explicitly:

```bash
git push origin main   # Forgejo + GitHub (configured on origin pushurl)
git push github main   # retry GitHub only
```

## Security requirements

- Use SSH remotes for push.
- Never store tokens or credentials inside remote URLs.
- Never commit real API keys/passwords into manifests or compose files.
- Verify with:

```bash
git remote -v
./scripts/validate.sh
```
