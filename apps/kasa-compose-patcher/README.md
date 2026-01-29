# Compose Patcher

Automatisches Re-Patchen von Docker-Compose-Dateien nach Umbrel App-Updates.

## Übersicht

Compose Patcher stellt benutzerdefinierte Änderungen an `docker-compose.yml`
automatisch wieder her, wenn Umbrel bei App-Updates die Konfiguration
überschreibt. Deklarative Patch-Regeln werden idempotent angewendet —
sicher, nachvollziehbar und mit automatischem Backup.

## Architektur

| Komponente | Beschreibung |
|---|---|
| **Host-Daemon** | Python-Service auf dem Host, führt Patches aus |
| **Systemd-Watcher** | Überwacht Dateisystem-Änderungen, triggert Patches |
| **Unix-Socket-API** | Sichere Kommunikation zwischen UI und Daemon |
| **Web-UI (diese App)** | Grafische Oberfläche zum Verwalten und Überwachen |

## Architektur-Anforderungen

| Architektur | Unterstützt |
|---|---|
| AMD64 (x86_64) | Ja |
| ARM64 (aarch64) | Ja |

## Funktionen

- 8 Patch-Operationen: add_volume, remove_volume, ensure_device, remove_device,
  set_env, unset_env, remove_key, replace_value
- Automatisches Backup vor jeder Änderung
- Baseline-Speicherung zum Vergleich (Diff-Ansicht)
- Validierung via `docker compose config` oder YAML-Syntax
- Dry-Run-Modus zur Vorschau
- Web-UI mit Patch-Editor, Toggle, Diff-Ansicht
- systemd Path-Watcher + Polling-Fallback
- flock-basiertes Locking gegen parallele Ausführung
- Token-gesicherte API über Unix-Domain-Socket

## Links

- **Repository:** [GitHub](https://github.com/willrobin/umbrel-community-app-store)
- **Issues:** [GitHub Issues](https://github.com/willrobin/umbrel-community-app-store/issues)

## Konfiguration

| Parameter | Wert |
|---|---|
| **Web-UI Port** | 3008 |
| **Interner Port** | 5000 |
| **Daten-Verzeichnis** | `/home/umbrel/compose-patcher` |
| **Patches** | `/home/umbrel/compose-patcher/patches/<app>.yml` |
| **Baselines** | `/home/umbrel/compose-patcher/baselines/<app>/` |
| **Logs** | `/home/umbrel/compose-patcher/logs/` |
| **API-Socket** | `/home/umbrel/compose-patcher/daemon.sock` |

## Erste Schritte

### 1. Host-Daemon installieren (einmalig, per SSH)

```bash
cd /home/umbrel
git clone https://github.com/willrobin/umbrel-community-app-store.git
cd umbrel-community-app-store/host/compose-patcher
sudo bash install.sh
```

### 2. Umbrel-App installieren

Installiere "Compose Patcher" aus dem Kasa Community App Store.

### 3. Patch erstellen

Erstelle eine Patch-Datei für eine App:

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

### 4. Patch testen und anwenden

```bash
compose-patcher dry-run --app plex
compose-patcher apply --app plex
```

Oder über die Web-UI: Dry Run und Anwenden per Button.

## Hinweise

- Der Host-Daemon muss separat installiert werden (per SSH).
- Nach UmbrelOS-Updates die systemd-Units ggf. neu installieren.
- Die UI zeigt den Installationsstatus und Reparatur-Anweisungen.
- Backups werden automatisch erstellt und rotiert (max. 20 pro App).
- Patches werden nur angewendet, wenn `enabled: true` gesetzt ist.

## Fehlerbehebung

| Problem | Lösung |
|---|---|
| UI zeigt "Daemon nicht installiert" | Host-Daemon per SSH installieren (siehe oben) |
| Patches werden nicht automatisch angewendet | `systemctl status compose-patcher.path` prüfen |
| Validierung schlägt fehl | `compose-patcher doctor` für Diagnose ausführen |
| Patch erzeugt ungültiges YAML | Backup wird automatisch wiederhergestellt; Patch prüfen |
| Nach Umbrel-Update fehlen systemd-Units | `sudo bash install.sh` erneut ausführen |
