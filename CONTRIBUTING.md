# Contributing

## App IDs
- Use lowercase letters, numbers, and dashes only (example: `my-app`).
- App ID must match the folder name under `apps/`.

## App Structure (required)
```
apps/<app-id>/
  umbrel-app.yml
  docker-compose.yml
  README.md
  icon.png (optional, stays here)
```

For Umbrel to discover apps, publish the app to the repo root:
`./scripts/publish.sh`

**IMPORTANT:** Root-level app directories (e.g., `kasa-azuracast/`) are auto-generated
by `publish.sh`. Do NOT manually edit or delete them. They are required for Umbrel
to discover apps. Always edit files in `apps/<app-id>/` and then run `publish.sh`.

## Persistence, Ports, Env, Secrets
- Persist only what is necessary using named volumes or host paths under Umbrel's data directory.
- Expose only required ports; prefer internal-only services.
- Keep environment variables documented in the app README.
- Do not commit secrets. Use placeholders and document how users should provide them.

## Versioning & Updates
- Follow semantic versioning in `umbrel-app.yml`.
- Update `releaseNotes` for each version bump.
- Keep `docker-compose.yml` aligned with the versioned image/tag.
