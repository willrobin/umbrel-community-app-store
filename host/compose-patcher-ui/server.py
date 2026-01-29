#!/usr/bin/env python3
"""
compose-patcher-ui — Web-UI für den Compose Patcher Daemon

Kommuniziert mit dem Host-Daemon über Unix-Domain-Socket.
Dient als Frontend innerhalb der Umbrel-App.
"""

import http.client
import json
import os
import socket
import sys

from flask import Flask, jsonify, render_template, request

app = Flask(__name__)

# Konfiguration via Umgebungsvariablen
DATA_DIR = os.environ.get("DATA_DIR", "/data")
SOCKET_PATH = os.path.join(DATA_DIR, "daemon.sock")
TOKEN_FILE = os.path.join(DATA_DIR, "daemon.token")


def get_token():
    """Lese den API-Token aus der Token-Datei."""
    try:
        with open(TOKEN_FILE) as f:
            return f.read().strip()
    except (OSError, FileNotFoundError):
        return ""


class UnixHTTPConnection(http.client.HTTPConnection):
    """HTTP-Verbindung über Unix-Domain-Socket."""

    def __init__(self, socket_path, timeout=10):
        super().__init__("localhost", timeout=timeout)
        self._socket_path = socket_path

    def connect(self):
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.settimeout(self.timeout)
        self.sock.connect(self._socket_path)


def daemon_request(method, path, body=None):
    """Sende HTTP-Request an den Daemon über Unix-Socket.

    Gibt (response_data, http_status) zurück.
    """
    try:
        conn = UnixHTTPConnection(SOCKET_PATH)
        headers = {
            "Authorization": f"Bearer {get_token()}",
            "Content-Type": "application/json",
        }
        conn.request(method, path, body=body, headers=headers)
        resp = conn.getresponse()
        raw = resp.read().decode("utf-8")
        try:
            data = json.loads(raw)
        except json.JSONDecodeError:
            data = {"raw": raw}
        return data, resp.status
    except FileNotFoundError:
        return {
            "error": "Daemon-Socket nicht gefunden. Ist der Daemon installiert und aktiv?",
            "daemon_unreachable": True,
            "socket_path": SOCKET_PATH,
        }, 503
    except ConnectionRefusedError:
        return {
            "error": "Verbindung zum Daemon abgelehnt. Bitte Daemon-Status prüfen.",
            "daemon_unreachable": True,
        }, 503
    except socket.timeout:
        return {
            "error": "Zeitüberschreitung bei Daemon-Verbindung.",
            "daemon_unreachable": True,
        }, 504
    except Exception as e:
        return {
            "error": f"Daemon-Kommunikation fehlgeschlagen: {e}",
            "daemon_unreachable": True,
        }, 503


# ─── Routen ───────────────────────────────────────────────────────────────────


@app.route("/")
def index():
    """Hauptseite der UI."""
    return render_template("index.html")


@app.route("/api/<path:subpath>", methods=["GET", "POST", "PUT"])
def proxy_api(subpath):
    """Proxy alle API-Requests an den Daemon."""
    body = (
        request.get_data()
        if request.method in ("POST", "PUT")
        else None
    )
    data, status = daemon_request(
        request.method, f"/api/{subpath}", body
    )
    return jsonify(data), status


@app.route("/api/daemon-check")
def daemon_check():
    """Prüfe ob der Daemon erreichbar und funktionsfähig ist."""
    reachable = os.path.exists(SOCKET_PATH)

    # Verzeichnisse prüfen
    dirs = {}
    for d in ["patches", "baselines", "logs"]:
        dirs[d] = os.path.isdir(os.path.join(DATA_DIR, d))

    token_exists = os.path.isfile(TOKEN_FILE)

    # Systemd-Unit-Dateien prüfen (über gemountete Pfade)
    systemd_units = {}
    for unit in [
        "compose-patcher-api.service",
        "compose-patcher.path",
        "compose-patcher-watcher.service",
    ]:
        unit_path = f"/etc/systemd/system/{unit}"
        systemd_units[unit] = os.path.isfile(unit_path)

    # Daemon-Verbindung testen
    daemon_alive = False
    daemon_version = None
    if reachable:
        try:
            data, status = daemon_request("GET", "/api/status")
            if status == 200 and not data.get("daemon_unreachable"):
                daemon_alive = True
                daemon_version = data.get("daemon_version")
        except Exception:
            pass

    return jsonify(
        {
            "socket_exists": reachable,
            "socket_path": SOCKET_PATH,
            "daemon_alive": daemon_alive,
            "daemon_version": daemon_version,
            "token_exists": token_exists,
            "directories": dirs,
            "systemd_units": systemd_units,
            "data_dir": DATA_DIR,
        }
    )


# ─── Startup ─────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    port = int(os.environ.get("PORT", "5000"))
    debug = os.environ.get("FLASK_DEBUG", "0") == "1"

    print(f"Compose Patcher UI startet auf Port {port}")
    print(f"  DATA_DIR:     {DATA_DIR}")
    print(f"  SOCKET_PATH:  {SOCKET_PATH}")
    print(f"  TOKEN_FILE:   {TOKEN_FILE}")

    app.run(host="0.0.0.0", port=port, debug=debug)
