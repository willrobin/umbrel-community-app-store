# App Checklist

## Basic Requirements

- [ ] App ID matches folder name and is lowercase with dashes
- [ ] `umbrel-app.yml` has correct metadata, version, and release notes
- [ ] `docker-compose.yml` uses non-root where possible
- [ ] `app_proxy` points at correct service (`<app-id>_<service>_1`) and `APP_PORT` matches container port
- [ ] Port in `umbrel-app.yml` is unique across apps
- [ ] Only required host ports are exposed (avoid `ports:` unless needed)
- [ ] Volumes use `${APP_DATA_DIR}` and are documented
- [ ] Environment variables are documented; no secrets committed
- [ ] Health checks implemented for all critical services
- [ ] README includes usage, configuration, and troubleshooting

## Architecture (Critical)

- [ ] **Docker images support multi-architecture** (AMD64 + ARM64)
  - Check: `docker manifest inspect <image>:<tag>`
  - If not multi-arch, document clearly which architectures are supported
- [ ] Image tags are pinned with SHA256 digest (not `:latest`)
- [ ] Digest is the **manifest list digest**, not architecture-specific

## Service Dependencies

- [ ] Services with dependencies use `depends_on` with `condition: service_healthy`
- [ ] Health checks have appropriate `start_period` for slow-starting services
- [ ] Database services have sufficient retry counts (10+ for production)

## Container Networking

- [ ] Service references use fully qualified names: `<app-id>_<service>_1`
- [ ] Database URLs use container names, not `localhost`
- [ ] No port conflicts with other apps in this store

## Publishing

- [ ] Run `./scripts/publish.sh` after editing files in `apps/`
- [ ] Run `./scripts/validate.sh` before committing
- [ ] Both `apps/<id>/` and root `<id>/` directories are in sync

## Testing

- [ ] App installs successfully on fresh Umbrel
- [ ] App survives restart (data persists)
- [ ] All services reach healthy state
- [ ] Web UI is accessible at configured port

## Common Issues

| Problem | Likely Cause | Solution |
|---------|--------------|----------|
| `exec format error` | Wrong architecture | Use correct image variant |
| `no matching manifest` | Image not multi-arch | Find alternative or build multi-arch |
| Container exits immediately | Missing dependencies | Check `depends_on` conditions |
| Connection refused | Wrong container name | Use `<app-id>_<service>_1` format |
| Database not ready | Insufficient start_period | Increase health check start_period |
