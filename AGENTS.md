# Agent Guidelines

These rules apply to Codex/Claude Code contributors working in this repo.

## Conventions
- Apps live in `apps/<app-id>/`.
- Required per app: `umbrel-app.yml`, `docker-compose.yml`, `README.md`.
- Templates live in `templates/` and should be kept minimal.
- Scripts live in `scripts/` and must be portable (macOS bash).

## Do / Don't
- Do keep changes small, scoped, and well-explained.
- Do update docs when behavior or structure changes.
- Don't add secrets or real credentials.
- Don't run unconfirmed destructive commands.
- Don't introduce breaking changes without calling them out.

## Workflow
1) Scaffold: `./scripts/new-app.sh <app-id> "<App Name>"`
2) Edit app files and README.
3) Validate: `./scripts/validate.sh`
4) Commit with message style: `type(scope): short summary` (example: `chore(apps): add foo`).

## PR / Commit Guidelines
- Keep commits small and reviewable.
- One logical change per commit.
- Explain migrations or breaking changes in the commit message body.

## Security Checklist (short)
- Use non-root containers where possible.
- Avoid exposing unnecessary ports.
- Persist only required data via volumes.
- Do not store secrets in repo or compose files.
