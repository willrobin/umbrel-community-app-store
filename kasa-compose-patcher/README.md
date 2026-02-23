# Compose Patcher

Automatically re-patch Docker Compose files after Umbrel app updates.

## Overview

Compose Patcher automatically restores custom changes to `docker-compose.yml`
when Umbrel overwrites the configuration during app updates. Declarative patch
rules are applied idempotently — safe, traceable, and with automatic backups.

## Architecture

| Component | Description |
|---|---|
| **Host Daemon** | Python service on the host that executes patches |
| **Systemd Watcher** | Monitors filesystem changes and triggers patches |
| **Unix Socket API** | Secure communication between UI and daemon |
| **Web UI (this app)** | Graphical interface for management and monitoring |

## Architecture Requirements

| Architecture | Supported |
|---|---|
| AMD64 (x86_64) | Yes |
| ARM64 (aarch64) | Yes |

## Features

- 8 patch operations: add_volume, remove_volume, ensure_device, remove_device,
  set_env, unset_env, remove_key, replace_value
- Automatic backup before every change
- Baseline storage for comparison (diff view)
- Validation via `docker compose config` or YAML syntax
- Dry-run mode for previewing changes
- Web UI with patch editor, toggle, and diff view
- systemd path watcher + polling fallback
- flock-based locking to prevent parallel execution
- Token-secured API over Unix domain socket

## Links

- **Repository:** [GitHub](https://github.com/willrobin/umbrel-community-app-store)
- **Issues:** [GitHub Issues](https://github.com/willrobin/umbrel-community-app-store/issues)

## Configuration

| Setting | Value |
|---|---|
| **Web UI Port** | 3008 |
| **Internal Port** | 5000 |
| **Data Directory** | `/home/umbrel/compose-patcher` |
| **Patches** | `/home/umbrel/compose-patcher/patches/<app>.yml` |
| **Baselines** | `/home/umbrel/compose-patcher/baselines/<app>/` |
| **Logs** | `/home/umbrel/compose-patcher/logs/` |
| **API Socket** | `/home/umbrel/compose-patcher/daemon.sock` |

## Getting Started

### 1. Install the host daemon (one-time, via SSH)

```bash
cd /home/umbrel
git clone https://github.com/willrobin/umbrel-community-app-store.git
cd umbrel-community-app-store/host/compose-patcher
sudo bash install.sh
```

### 2. Install the Umbrel app

Install "Compose Patcher" from the Kasa Community App Store.

### 3. Create a patch

Create a patch file for an app:

```bash
cat > /home/umbrel/compose-patcher/patches/plex.yml << 'EOF'
enabled: true
ops:
  - op: add_volume
    service: plex
    value: "/mnt/usb/media:/media:ro"
  - op: ensure_device
    service: plex
    value: "/dev/dri:/dev/dri"
EOF
```

### 4. Test and apply the patch

```bash
compose-patcher dry-run --app plex
compose-patcher apply --app plex
```

Or use the web UI: Dry Run and Apply via buttons.

## Notes

- The host daemon must be installed separately (via SSH).
- After umbrelOS updates, you may need to reinstall the systemd units.
- The UI shows the installation status and repair instructions.
- Backups are automatically created and rotated (max 20 per app).
- Patches are only applied when `enabled: true` is set.

## Troubleshooting

| Problem | Solution |
|---|---|
| UI shows "Daemon not installed" | Install the host daemon via SSH (see above) |
| Patches are not applied automatically | Check `systemctl status compose-patcher.path` |
| Validation fails | Run `compose-patcher doctor` for diagnostics |
| Patch produces invalid YAML | Backup is automatically restored; review the patch |
| systemd units missing after Umbrel update | Run `sudo bash install.sh` again |
