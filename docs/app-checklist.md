# App Checklist

- App ID matches folder name and is lowercase with dashes.
- `umbrel-app.yml` has correct metadata, version, and release notes.
- `docker-compose.yml` uses non-root where possible.
- `app_proxy` points at the correct service and `APP_PORT` matches the container port.
- `umbrel-app.yml` port is unique across apps and in the typical Umbrel range when possible.
- Only required host ports are exposed (avoid `ports:` unless needed).
- Volumes/persistence use `${APP_DATA_DIR}` (prefer) and are documented.
- Environment variables are documented; no secrets committed.
- Healthchecks (if supported) and logs are reasonable.
- README includes usage and update notes.
