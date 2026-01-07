# App Checklist

- App ID matches folder name and is lowercase with dashes.
- `umbrel-app.yml` has correct metadata, version, and release notes.
- `docker-compose.yml` uses non-root where possible.
- Only required ports are exposed.
- Volumes/persistence are defined and documented.
- Environment variables are documented; no secrets committed.
- Healthchecks (if supported) and logs are reasonable.
- README includes usage and update notes.
