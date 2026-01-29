#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# compose-patcher — Installations-Skript für UmbrelOS 1.5
#
# Dieses Skript installiert den Compose Patcher Daemon auf dem Host-System.
# Es erstellt die Verzeichnisstruktur, kopiert den Daemon, installiert
# systemd-Units und aktiviert den automatischen Watcher.
#
# Nutzung:
#   sudo bash install.sh
#
# Voraussetzungen:
#   - UmbrelOS 1.5 (oder kompatibles Debian/Ubuntu-System)
#   - Python 3.8+ mit pip
#   - root-Rechte (sudo)
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# Konfiguration
PATCHER_HOME="/home/umbrel/compose-patcher"
UMBREL_APP_DATA="/home/umbrel/umbrel/app-data"
SYSTEMD_DIR="/etc/systemd/system"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Farben für Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Keine Farbe

info()  { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[FEHLER]${NC} $1" >&2; }

# ─── Root-Prüfung ────────────────────────────────────────────────────────────

if [[ $EUID -ne 0 ]]; then
    error "Dieses Skript muss als root ausgeführt werden."
    echo "  Bitte erneut mit: sudo bash $0"
    exit 1
fi

# ─── Python-Prüfung ──────────────────────────────────────────────────────────

info "Prüfe Python-Installation..."
if command -v python3 &>/dev/null; then
    PYTHON=$(command -v python3)
    PY_VERSION=$($PYTHON --version 2>&1 | awk '{print $2}')
    info "Python gefunden: $PYTHON ($PY_VERSION)"
else
    error "Python 3 nicht gefunden. Bitte installieren:"
    echo "  sudo apt-get install python3 python3-pip"
    exit 1
fi

# ─── PyYAML installieren ─────────────────────────────────────────────────────

info "Prüfe PyYAML..."
if $PYTHON -c "import yaml" 2>/dev/null; then
    info "PyYAML ist bereits installiert."
else
    info "Installiere PyYAML..."
    if command -v pip3 &>/dev/null; then
        pip3 install --quiet pyyaml
    elif $PYTHON -m pip --version &>/dev/null; then
        $PYTHON -m pip install --quiet pyyaml
    else
        error "pip nicht gefunden. Bitte installieren:"
        echo "  sudo apt-get install python3-pip"
        echo "  pip3 install pyyaml"
        exit 1
    fi
    info "PyYAML installiert."
fi

# ─── Verzeichnisse erstellen ─────────────────────────────────────────────────

info "Erstelle Verzeichnisstruktur..."
mkdir -p "${PATCHER_HOME}"/{bin,patches,baselines,logs}

# ─── Daemon-Skript kopieren ──────────────────────────────────────────────────

info "Installiere compose-patcher Daemon..."
cp "${SCRIPT_DIR}/bin/compose-patcher" "${PATCHER_HOME}/bin/compose-patcher"
chmod 755 "${PATCHER_HOME}/bin/compose-patcher"

# Symlink in /usr/local/bin für einfachen Zugriff
ln -sf "${PATCHER_HOME}/bin/compose-patcher" /usr/local/bin/compose-patcher
info "Daemon installiert: ${PATCHER_HOME}/bin/compose-patcher"
info "CLI verfügbar als: /usr/local/bin/compose-patcher"

# ─── Daemon initialisieren ───────────────────────────────────────────────────

info "Initialisiere Daemon..."
"${PATCHER_HOME}/bin/compose-patcher" init

# ─── Systemd-Units installieren ──────────────────────────────────────────────

info "Installiere systemd-Units..."

# API-Service (Daemon mit Unix Socket + Polling-Watcher)
cp "${SCRIPT_DIR}/systemd/compose-patcher-api.service" \
   "${SYSTEMD_DIR}/compose-patcher-api.service"

# Path-Watcher (systemd-basierte Dateisystemüberwachung)
cp "${SCRIPT_DIR}/systemd/compose-patcher.path" \
   "${SYSTEMD_DIR}/compose-patcher.path"

# Watcher-Service (wird durch Path-Unit getriggert)
cp "${SCRIPT_DIR}/systemd/compose-patcher-watcher.service" \
   "${SYSTEMD_DIR}/compose-patcher-watcher.service"

info "Systemd-Units installiert."

# ─── Systemd aktivieren ──────────────────────────────────────────────────────

info "Aktiviere und starte Services..."
systemctl daemon-reload

# API-Server starten und aktivieren
systemctl enable compose-patcher-api.service
systemctl start compose-patcher-api.service

# Path-Watcher aktivieren
systemctl enable compose-patcher.path
systemctl start compose-patcher.path

info "Services aktiviert und gestartet."

# ─── Berechtigungen setzen ───────────────────────────────────────────────────

info "Setze Berechtigungen..."
# Token-Datei nur für root und die Gruppe lesbar (UI-Container)
if [[ -f "${PATCHER_HOME}/daemon.token" ]]; then
    chmod 640 "${PATCHER_HOME}/daemon.token"
fi

# Socket ist durch die systemd-Unit gesetzt
# Verzeichnis-Berechtigungen: root und Gruppe 'umbrel' (falls vorhanden)
chown -R root:root "${PATCHER_HOME}"
if getent group umbrel &>/dev/null; then
    chgrp -R umbrel "${PATCHER_HOME}"
    chmod -R g+rX "${PATCHER_HOME}"
    chmod g+rw "${PATCHER_HOME}/patches"
    if [[ -f "${PATCHER_HOME}/daemon.token" ]]; then
        chmod 640 "${PATCHER_HOME}/daemon.token"
    fi
fi

# ─── Überprüfung ─────────────────────────────────────────────────────────────

info "Führe Diagnose durch..."
echo ""
"${PATCHER_HOME}/bin/compose-patcher" doctor
echo ""

# ─── Abschluss ───────────────────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
info "Installation abgeschlossen!"
echo ""
echo "  Befehle:"
echo "    compose-patcher status          — Status anzeigen"
echo "    compose-patcher apply --all     — Alle Patches anwenden"
echo "    compose-patcher apply --app X   — Patch für App X anwenden"
echo "    compose-patcher dry-run --app X — Patch simulieren"
echo "    compose-patcher diff --app X    — Diff anzeigen"
echo "    compose-patcher doctor          — Diagnose"
echo ""
echo "  Patches ablegen unter:"
echo "    ${PATCHER_HOME}/patches/<app-name>.yml"
echo ""
echo "  Services verwalten:"
echo "    systemctl status compose-patcher-api"
echo "    systemctl status compose-patcher.path"
echo "    journalctl -u compose-patcher-api -f"
echo ""
echo "═══════════════════════════════════════════════════════════════"
