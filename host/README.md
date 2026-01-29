# Compose Patcher — Host-Komponente

Automatisches Re-Patchen von Umbrel App `docker-compose.yml` Dateien nach Updates.

## Überblick

Der Compose Patcher Daemon läuft als systemd-Service auf dem UmbrelOS-Host und
überwacht Änderungen an App-Compose-Dateien. Wenn Umbrel bei einem App-Update
die `docker-compose.yml` überschreibt, werden benutzerdefinierte Patches
automatisch wieder angewendet.

## Komponenten

```
/home/umbrel/compose-patcher/
├── bin/compose-patcher          # Hauptprogramm (Python CLI + API-Server)
├── patches/                     # Patch-Regeln pro App (*.yml)
├── baselines/                   # Baseline-Kopien der Compose-Dateien
│   └── <app>/
│       ├── latest.yml → ...     # Symlink auf letzte Baseline
│       └── 20250129_123456_abc123.yml
├── logs/                        # Log-Dateien
├── daemon.sock                  # Unix-Socket für API-Kommunikation
├── daemon.token                 # API-Token (chmod 600)
├── state.json                   # Persistenter Zustand
└── patcher.lock                 # flock für parallele Ausführung
```

## Schnellstart

### Installation

```bash
# Auf dem Umbrel-Host per SSH:
cd /home/umbrel
git clone https://github.com/willrobin/umbrel-community-app-store.git
cd umbrel-community-app-store/host/compose-patcher
sudo bash install.sh
```

### Status prüfen

```bash
compose-patcher status
compose-patcher doctor
systemctl status compose-patcher-api
systemctl status compose-patcher.path
```

### Patch erstellen

```bash
# Beispiel: USB-Volume und GPU-Passthrough für Plex
cat > /home/umbrel/compose-patcher/patches/plex.yml << 'EOF'
enabled: true
ops:
  - op: add_volume
    service: plex
    value: "/mnt/usb/media:/media:ro"

  - op: ensure_device
    service: plex
    value: "/dev/dri:/dev/dri"

  - op: set_env
    service: plex
    key: PLEX_CLAIM
    value: "claim-xxxxxxxxxxxx"
EOF
```

### Patch anwenden

```bash
# Vorschau (Dry Run)
compose-patcher dry-run --app plex

# Anwenden
compose-patcher apply --app plex

# Alle aktiven Patches anwenden
compose-patcher apply --all

# Diff: Baseline vs. aktuelle Compose-Datei
compose-patcher diff --app plex
```

## Patch-Format

Jede Patch-Datei ist ein YAML-Dokument mit folgendem Aufbau:

```yaml
enabled: true          # Patch aktiv (true) oder deaktiviert (false)
ops:                   # Liste der Operationen
  - op: <operation>
    service: <service-name>
    value: <wert>      # je nach Operation
    key: <schlüssel>   # für set_env/unset_env
    path: <pfad>       # für remove_key/replace_value (Punkt-getrennt)
```

### Verfügbare Operationen

| Operation | Beschreibung | Parameter |
|---|---|---|
| `add_volume` | Volume hinzufügen (wenn nicht vorhanden) | `service`, `value` |
| `remove_volume` | Volume entfernen | `service`, `value` |
| `ensure_device` | Device hinzufügen (wenn nicht vorhanden) | `service`, `value` |
| `remove_device` | Device entfernen | `service`, `value` |
| `set_env` | Umgebungsvariable setzen (List- und Map-Style) | `service`, `key`, `value` |
| `unset_env` | Umgebungsvariable entfernen | `service`, `key` |
| `remove_key` | Schlüssel aus Service-Config entfernen | `service`, `path` |
| `replace_value` | Wert an Pfad ersetzen | `service`, `path`, `value` |

### Beispiele

```yaml
# Volume hinzufügen
- op: add_volume
  service: server
  value: "/mnt/nas/data:/data:ro"

# Gerät durchreichen
- op: ensure_device
  service: server
  value: "/dev/ttyUSB0:/dev/ttyUSB0"

# Umgebungsvariable setzen (funktioniert mit List- und Map-Style)
- op: set_env
  service: app
  key: TZ
  value: "Europe/Berlin"

# Umgebungsvariable entfernen
- op: unset_env
  service: app
  key: DEBUG

# Schlüssel komplett entfernen (z.B. "devices" Block)
- op: remove_key
  service: server
  path: devices

# Wert ersetzen (z.B. restart-Policy ändern)
- op: replace_value
  service: server
  path: restart
  value: "always"
```

## CLI-Befehle

| Befehl | Beschreibung |
|---|---|
| `compose-patcher init` | Verzeichnisse und Token initialisieren |
| `compose-patcher status` | Daemon-Status (JSON) anzeigen |
| `compose-patcher apply --app <name>` | Patch für eine App anwenden |
| `compose-patcher apply --all` | Alle aktiven Patches anwenden |
| `compose-patcher dry-run --app <name>` | Patch simulieren, Diff anzeigen |
| `compose-patcher diff --app <name>` | Diff: Baseline vs. aktuelle Datei |
| `compose-patcher doctor` | Umgebungsprüfung und Diagnose |
| `compose-patcher serve` | API-Server + Watcher starten |

## systemd-Units

| Unit | Typ | Beschreibung |
|---|---|---|
| `compose-patcher-api.service` | Service | API-Server + Polling-Watcher |
| `compose-patcher.path` | Path | Dateisystem-Watcher für app-data |
| `compose-patcher-watcher.service` | Service (oneshot) | Patches nach Path-Trigger anwenden |

### Verwaltung

```bash
# Status prüfen
systemctl status compose-patcher-api
systemctl status compose-patcher.path

# Logs anzeigen
journalctl -u compose-patcher-api -f
journalctl -u compose-patcher-watcher --since today

# Neustarten
sudo systemctl restart compose-patcher-api

# Deaktivieren
sudo systemctl stop compose-patcher-api compose-patcher.path
sudo systemctl disable compose-patcher-api compose-patcher.path
```

## Sicherheit

- **Backup vor jeder Änderung:** `<compose>.bak.<timestamp>`
- **Validierung:** `docker compose config` oder YAML-Syntax-Prüfung
- **Atomare Ersetzung:** temp → rename (kein korruptes Compose möglich)
- **Automatisches Restore:** Bei Fehler wird Backup wiederhergestellt
- **flock-Locking:** Verhindert parallele Ausführung
- **Token-Auth:** API-Zugriff über zufälligen Token gesichert
- **Unix-Socket:** Kein Netzwerkzugriff, nur lokal erreichbar
- **Keine Secrets in Logs:** Umgebungsvariablen-Werte werden nicht geloggt
- **Backup-Rotation:** Maximal 20 Backups pro App

## Reparatur nach UmbrelOS-Update

Falls ein Umbrel-Update die systemd-Units entfernt hat:

```bash
# Prüfe ob Daemon noch vorhanden
ls -la /home/umbrel/compose-patcher/bin/compose-patcher

# Falls ja: Units neu installieren
cd /home/umbrel/umbrel-community-app-store/host/compose-patcher
sudo bash install.sh

# Status prüfen
compose-patcher doctor
```

## Deinstallation

```bash
cd /home/umbrel/umbrel-community-app-store/host/compose-patcher
sudo bash uninstall.sh
```

Patches und Baselines bleiben erhalten. Zum vollständigen Entfernen:

```bash
sudo rm -rf /home/umbrel/compose-patcher
```

## Docker-Image bauen (UI)

```bash
cd /home/umbrel/umbrel-community-app-store/host/compose-patcher-ui
docker build -t ghcr.io/willrobin/compose-patcher-ui:1.0.0 .
docker push ghcr.io/willrobin/compose-patcher-ui:1.0.0
```
