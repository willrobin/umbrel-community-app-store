#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# compose-patcher — Deinstallations-Skript
#
# Entfernt den Compose Patcher Daemon und die systemd-Units.
# Patches und Baselines werden NICHT gelöscht (Sicherheit).
#
# Nutzung:
#   sudo bash uninstall.sh
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PATCHER_HOME="/home/umbrel/compose-patcher"
SYSTEMD_DIR="/etc/systemd/system"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[FEHLER]${NC} Dieses Skript muss als root ausgeführt werden." >&2
    exit 1
fi

info "Stoppe Services..."
systemctl stop compose-patcher-api.service 2>/dev/null || true
systemctl stop compose-patcher.path 2>/dev/null || true
systemctl stop compose-patcher-watcher.service 2>/dev/null || true

info "Deaktiviere Services..."
systemctl disable compose-patcher-api.service 2>/dev/null || true
systemctl disable compose-patcher.path 2>/dev/null || true
systemctl disable compose-patcher-watcher.service 2>/dev/null || true

info "Entferne systemd-Units..."
rm -f "${SYSTEMD_DIR}/compose-patcher-api.service"
rm -f "${SYSTEMD_DIR}/compose-patcher.path"
rm -f "${SYSTEMD_DIR}/compose-patcher-watcher.service"
systemctl daemon-reload

info "Entferne CLI-Symlink..."
rm -f /usr/local/bin/compose-patcher

info "Entferne Daemon-Binary und Logs..."
rm -f "${PATCHER_HOME}/bin/compose-patcher"
rm -f "${PATCHER_HOME}/daemon.sock"
rm -f "${PATCHER_HOME}/daemon.token"
rm -f "${PATCHER_HOME}/patcher.lock"
rm -f "${PATCHER_HOME}/state.json"
rm -rf "${PATCHER_HOME}/logs"
rm -rf "${PATCHER_HOME}/bin"

echo ""
warn "Patches und Baselines wurden NICHT gelöscht:"
echo "  ${PATCHER_HOME}/patches/"
echo "  ${PATCHER_HOME}/baselines/"
echo ""
warn "Um alles zu entfernen:"
echo "  sudo rm -rf ${PATCHER_HOME}"
echo ""
info "Deinstallation abgeschlossen."
