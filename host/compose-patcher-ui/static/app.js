/**
 * compose-patcher-ui — Frontend-Logik
 *
 * Kommuniziert mit dem Flask-Backend, das API-Calls an den
 * Host-Daemon (Unix Socket) weiterleitet.
 */

// ─── State ───────────────────────────────────────────────────────────────────

let currentAppId = null;
let daemonAlive = false;

// ─── API-Hilfsfunktionen ────────────────────────────────────────────────────

async function apiGet(path) {
    try {
        const resp = await fetch(`/api/${path}`);
        return await resp.json();
    } catch (e) {
        return { error: e.message, daemon_unreachable: true };
    }
}

async function apiPost(path, body = null) {
    try {
        const resp = await fetch(`/api/${path}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: body ? JSON.stringify(body) : null,
        });
        return await resp.json();
    } catch (e) {
        return { error: e.message, daemon_unreachable: true };
    }
}

async function apiPut(path, body) {
    try {
        const resp = await fetch(`/api/${path}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body),
        });
        return await resp.json();
    } catch (e) {
        return { error: e.message, daemon_unreachable: true };
    }
}

// ─── Tab-Navigation ──────────────────────────────────────────────────────────

document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', () => {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        tab.classList.add('active');
        const target = document.getElementById('tab-' + tab.dataset.tab);
        if (target) target.classList.add('active');

        // Daten laden bei Tab-Wechsel
        if (tab.dataset.tab === 'apps') loadApps();
        if (tab.dataset.tab === 'install') loadInstallCheck();
    });
});

// ─── Daemon-Check ────────────────────────────────────────────────────────────

async function checkDaemon() {
    const badge = document.getElementById('daemon-status');
    const version = document.getElementById('daemon-version');

    try {
        const resp = await fetch('/api/daemon-check');
        const data = await resp.json();

        daemonAlive = data.daemon_alive;

        if (data.daemon_alive) {
            badge.textContent = 'Online';
            badge.className = 'status-badge online';
            if (data.daemon_version) {
                version.textContent = 'v' + data.daemon_version;
            }
        } else if (data.socket_exists) {
            badge.textContent = 'Socket vorhanden, Daemon antwortet nicht';
            badge.className = 'status-badge offline';
        } else {
            badge.textContent = 'Daemon nicht installiert';
            badge.className = 'status-badge offline';
        }
    } catch (e) {
        badge.textContent = 'Verbindungsfehler';
        badge.className = 'status-badge offline';
    }
}

// ─── Status laden ────────────────────────────────────────────────────────────

async function loadStatus() {
    const el = document.getElementById('status-content');

    if (!daemonAlive) {
        el.innerHTML = '<p class="hint">Daemon nicht erreichbar. Bitte unter "Installation" prüfen.</p>';
        return;
    }

    const data = await apiGet('status');

    if (data.error || data.daemon_unreachable) {
        el.innerHTML = `<p class="hint">Daemon nicht erreichbar: ${data.error || 'unbekannt'}</p>`;
        return;
    }

    el.innerHTML = `
        <div class="status-grid">
            <div class="status-item">
                <span class="label">Version</span>
                <span class="value">${data.daemon_version || '-'}</span>
            </div>
            <div class="status-item">
                <span class="label">Letzter Lauf</span>
                <span class="value">${formatDate(data.last_run)}</span>
            </div>
            <div class="status-item">
                <span class="label">Gesamt-Läufe</span>
                <span class="value">${data.runs_total || 0}</span>
            </div>
            <div class="status-item">
                <span class="label">App-Data vorhanden</span>
                <span class="value">${data.app_data_exists ? 'Ja' : 'Nein'}</span>
            </div>
            <div class="status-item">
                <span class="label">API-Service</span>
                <span class="value">${data.systemd_compose_patcher_api_service || 'unbekannt'}</span>
            </div>
            <div class="status-item">
                <span class="label">Path-Watcher</span>
                <span class="value">${data.systemd_compose_patcher_path || 'unbekannt'}</span>
            </div>
        </div>
        ${data.last_error ? `
            <div class="hint" style="margin-top:12px; border-color: rgba(244,67,54,0.3); background: rgba(244,67,54,0.08);">
                <strong>Letzter Fehler:</strong> ${data.last_error.message || '-'}
                (${formatDate(data.last_error.time)})
            </div>
        ` : ''}
    `;
}

// ─── Doctor ──────────────────────────────────────────────────────────────────

async function loadDoctor() {
    const el = document.getElementById('doctor-content');
    el.innerHTML = '<p class="loading">Diagnose läuft...</p>';

    const data = await apiGet('doctor');

    if (data.error || data.daemon_unreachable) {
        el.innerHTML = `<p class="hint">Daemon nicht erreichbar: ${data.error || 'unbekannt'}</p>`;
        return;
    }

    const checks = data.checks || [];
    let html = '<ul class="check-list">';
    for (const c of checks) {
        let iconClass = 'fail';
        let iconText = '!';
        if (c.status === 'ok') {
            iconClass = 'ok';
            iconText = '+';
        } else if (c.status === 'warnung') {
            iconClass = 'warn';
            iconText = '!';
        }
        html += `
            <li class="check-item">
                <span class="check-icon ${iconClass}">${iconText}</span>
                <span class="check-name">${esc(c.check)}</span>
                <span class="check-detail">${esc(c.detail)}</span>
            </li>
        `;
    }
    html += '</ul>';
    el.innerHTML = html;
}

// ─── Apps laden ──────────────────────────────────────────────────────────────

async function loadApps() {
    const el = document.getElementById('apps-list');

    if (!daemonAlive) {
        el.innerHTML = '<p class="hint">Daemon nicht erreichbar. Apps können nicht geladen werden.</p>';
        return;
    }

    el.innerHTML = '<p class="loading">Lade Apps...</p>';
    const data = await apiGet('apps');

    if (data.error || data.daemon_unreachable) {
        el.innerHTML = `<p class="hint">Fehler: ${data.error || 'Daemon nicht erreichbar'}</p>`;
        return;
    }

    const apps = data.apps || [];
    if (apps.length === 0) {
        el.innerHTML = '<p class="hint">Keine installierten Apps gefunden.</p>';
        return;
    }

    let html = `
        <table class="apps-table">
            <thead>
                <tr>
                    <th>App</th>
                    <th>Patch</th>
                    <th>Letzter Lauf</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
    `;
    for (const app of apps) {
        let badge = '<span class="badge badge-inactive">Kein Patch</span>';
        if (app.has_patch && app.patch_enabled) {
            badge = '<span class="badge badge-active">Aktiv</span>';
        } else if (app.has_patch) {
            badge = '<span class="badge badge-inactive">Deaktiviert</span>';
        }

        let statusBadge = '';
        if (app.last_success === true) {
            statusBadge = '<span class="badge badge-active">OK</span>';
        } else if (app.last_success === false) {
            statusBadge = '<span class="badge badge-error">Fehler</span>';
        }

        html += `
            <tr class="app-row" onclick="openAppDetail('${esc(app.id)}')">
                <td><strong>${esc(app.id)}</strong></td>
                <td>${badge}</td>
                <td>${formatDate(app.last_run)}</td>
                <td>${statusBadge}</td>
            </tr>
        `;
    }
    html += '</tbody></table>';
    el.innerHTML = html;
}

// ─── App Detail ──────────────────────────────────────────────────────────────

async function openAppDetail(appId) {
    currentAppId = appId;
    const el = document.getElementById('app-detail');
    const title = document.getElementById('app-detail-title');
    title.textContent = appId;
    el.style.display = 'block';

    // Patch laden
    const patchData = await apiGet(`apps/${appId}/patch`);
    const editor = document.getElementById('patch-editor');
    editor.value = patchData.content || '';

    // Patch-Status setzen
    const toggle = document.getElementById('patch-enabled');
    if (patchData.exists) {
        try {
            // 'enabled' aus dem YAML-Content parsen
            const match = patchData.content.match(/^enabled:\s*(true|false)/m);
            toggle.checked = match ? match[1] === 'true' : false;
        } catch {
            toggle.checked = false;
        }
    } else {
        toggle.checked = false;
    }

    // Diff und Result leeren
    document.getElementById('diff-output').textContent = '';
    document.getElementById('app-result').textContent = '';

    // Zum Detail scrollen
    el.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function closeAppDetail() {
    document.getElementById('app-detail').style.display = 'none';
    currentAppId = null;
}

// ─── Patch-Aktionen ──────────────────────────────────────────────────────────

async function savePatch() {
    if (!currentAppId) return;
    const content = document.getElementById('patch-editor').value;
    const result = document.getElementById('app-result');

    result.textContent = 'Speichere...';
    const data = await apiPut(`apps/${currentAppId}/patch`, { content });

    if (data.ok) {
        result.textContent = data.message || 'Patch gespeichert.';
        result.style.color = 'var(--success)';
    } else {
        result.textContent = 'Fehler: ' + (data.error || 'Unbekannt');
        result.style.color = 'var(--error)';
    }
    setTimeout(() => { result.style.color = ''; }, 3000);
}

async function togglePatch() {
    if (!currentAppId) return;
    const enabled = document.getElementById('patch-enabled').checked;
    const result = document.getElementById('app-result');

    const data = await apiPost(`apps/${currentAppId}/toggle`, { enabled });
    result.textContent = data.ok
        ? `Patch ${enabled ? 'aktiviert' : 'deaktiviert'}.`
        : 'Fehler: ' + (data.error || 'Unbekannt');

    // Apps-Liste aktualisieren
    loadApps();
}

async function dryRun() {
    if (!currentAppId) return;
    const result = document.getElementById('app-result');
    const diffEl = document.getElementById('diff-output');

    result.textContent = 'Führe Dry-Run durch...';
    const data = await apiPost(`apps/${currentAppId}/dry-run`);

    result.textContent = data.message || '';
    if (data.diff) {
        diffEl.textContent = data.diff;
        colorDiff(diffEl);
    } else {
        diffEl.textContent = data.message || 'Keine Änderungen.';
    }
}

async function applyPatch() {
    if (!currentAppId) return;
    const result = document.getElementById('app-result');
    const diffEl = document.getElementById('diff-output');

    result.textContent = 'Wende Patch an...';
    const data = await apiPost(`apps/${currentAppId}/apply`);

    result.textContent = data.message || '';
    if (data.success) {
        result.style.color = 'var(--success)';
    } else {
        result.style.color = 'var(--error)';
    }
    setTimeout(() => { result.style.color = ''; }, 3000);

    if (data.diff) {
        diffEl.textContent = data.diff;
        colorDiff(diffEl);
    }

    loadApps();
}

async function loadDiff() {
    if (!currentAppId) return;
    const diffEl = document.getElementById('diff-output');

    diffEl.textContent = 'Lade Diff...';
    const data = await apiGet(`apps/${currentAppId}/diff`);

    if (data.error) {
        diffEl.textContent = 'Fehler: ' + data.error;
    } else if (data.diff) {
        diffEl.textContent = data.diff;
        colorDiff(diffEl);
    } else {
        diffEl.textContent = data.message || 'Keine Unterschiede.';
    }
}

async function applyAll() {
    const el = document.getElementById('apply-all-result');
    el.innerHTML = '<p class="loading">Wende alle Patches an...</p>';

    const data = await apiPost('apply-all');

    if (data.error) {
        el.innerHTML = `<p style="color:var(--error)">Fehler: ${esc(data.error)}</p>`;
        return;
    }

    const results = data.results || [];
    if (results.length === 0) {
        el.innerHTML = '<p class="hint">Keine aktiven Patches vorhanden.</p>';
        return;
    }

    let html = '<ul class="check-list">';
    for (const r of results) {
        const icon = r.success ? 'ok' : 'fail';
        const text = r.success ? '+' : '!';
        html += `
            <li class="check-item">
                <span class="check-icon ${icon}">${text}</span>
                <span class="check-name">${esc(r.app)}</span>
                <span class="check-detail">${esc(r.message)}</span>
            </li>
        `;
    }
    html += '</ul>';
    el.innerHTML = html;
}

// ─── Install Check ───────────────────────────────────────────────────────────

async function loadInstallCheck() {
    const el = document.getElementById('install-check');

    try {
        const resp = await fetch('/api/daemon-check');
        const data = await resp.json();

        let html = '<div class="install-status">';

        // Socket
        html += installItem(
            data.socket_exists,
            'Daemon-Socket',
            data.socket_exists ? 'Vorhanden' : 'Nicht gefunden'
        );

        // Daemon aktiv
        html += installItem(
            data.daemon_alive,
            'Daemon aktiv',
            data.daemon_alive ? `Ja (v${data.daemon_version || '?'})` : 'Nein'
        );

        // Token
        html += installItem(
            data.token_exists,
            'API-Token',
            data.token_exists ? 'Vorhanden' : 'Nicht gefunden'
        );

        // Verzeichnisse
        const dirs = data.directories || {};
        for (const [name, exists] of Object.entries(dirs)) {
            html += installItem(exists, `Verzeichnis: ${name}`, exists ? 'OK' : 'Fehlt');
        }

        // Systemd Units
        const units = data.systemd_units || {};
        for (const [name, exists] of Object.entries(units)) {
            html += installItem(exists, `Unit: ${name}`, exists ? 'Installiert' : 'Fehlt');
        }

        html += '</div>';

        // Zusammenfassung
        if (data.daemon_alive) {
            html += '<p style="margin-top:12px; color:var(--success)">Daemon ist installiert und aktiv.</p>';
        } else {
            html += '<p style="margin-top:12px; color:var(--warning)">Daemon ist nicht aktiv. Bitte Installationsanleitung unten folgen.</p>';
        }

        el.innerHTML = html;
    } catch (e) {
        el.innerHTML = '<p class="hint">Prüfung fehlgeschlagen: ' + e.message + '</p>';
    }
}

function installItem(ok, label, detail) {
    const dot = ok ? 'green' : 'red';
    return `
        <div class="install-item">
            <span class="install-dot ${dot}"></span>
            <span>${esc(label)}: <strong>${esc(detail)}</strong></span>
        </div>
    `;
}

// ─── Hilfsfunktionen ─────────────────────────────────────────────────────────

function formatDate(iso) {
    if (!iso) return '-';
    try {
        const d = new Date(iso);
        return d.toLocaleString('de-DE', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
        });
    } catch {
        return iso;
    }
}

function esc(str) {
    if (!str) return '';
    const div = document.createElement('div');
    div.textContent = String(str);
    return div.innerHTML;
}

function colorDiff(el) {
    // Einfache Farbgebung für Diff-Ausgabe via HTML
    const lines = el.textContent.split('\n');
    let html = '';
    for (const line of lines) {
        if (line.startsWith('+++') || line.startsWith('---')) {
            html += `<span style="color:var(--text-muted)">${esc(line)}</span>\n`;
        } else if (line.startsWith('+')) {
            html += `<span style="color:var(--success)">${esc(line)}</span>\n`;
        } else if (line.startsWith('-')) {
            html += `<span style="color:var(--error)">${esc(line)}</span>\n`;
        } else if (line.startsWith('@@')) {
            html += `<span style="color:var(--accent)">${esc(line)}</span>\n`;
        } else {
            html += esc(line) + '\n';
        }
    }
    el.innerHTML = html;
}

// ─── Initialisierung ─────────────────────────────────────────────────────────

async function init() {
    await checkDaemon();
    loadStatus();
    loadInstallCheck();
}

// Automatisches Refresh alle 30 Sekunden
setInterval(checkDaemon, 30000);

// Start
init();
