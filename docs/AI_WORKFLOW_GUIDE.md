# AI Workflow Guide
# Systematische Abarbeitung von Optimierungs-Tasks für Claude Code & ChatGPT Codex

> **Zielgruppe**: KI-Assistenten (Claude Code, ChatGPT Codex, etc.)
> **Zweck**: Schritt-für-Schritt Anleitung zur Abarbeitung von GitHub Issues
> **Kontext**: umbrelOS 1.5 App Optimierung für Kasa Community App Store

---

## 📋 Übersicht

Dieser Guide erklärt, wie KI-Assistenten systematisch Optimierungs-Tasks aus dem GitHub Project Board abarbeiten können.

### Workflow auf einen Blick

```
┌─────────────────────────────────────────────────────────────┐
│                     KI-Assistent Workflow                    │
└─────────────────────────────────────────────────────────────┘

1. TASK AUSWAHL
   ├─ GitHub Issues mit Label "ai-ready" durchsuchen
   ├─ Issue mit höchster Priorität wählen
   └─ Issue-Beschreibung und Acceptance Criteria lesen

2. BRANCH ERSTELLEN
   ├─ Format: claude/optimization-{issue-num}-{kurz}-{session}
   └─ Von main/master Branch abzweigen

3. KONTEXT SAMMELN
   ├─ Relevante Dateien lesen (siehe "Files to Modify")
   ├─ Bestehende Patterns verstehen
   └─ CLAUDE.md Richtlinien beachten

4. IMPLEMENTIERUNG
   ├─ Änderungen in apps/{app-id}/ durchführen
   ├─ Acceptance Criteria als Checkliste abarbeiten
   └─ Keine Änderungen in root/ Verzeichnissen!

5. VALIDIERUNG
   ├─ ./scripts/publish.sh ausführen
   ├─ ./scripts/validate.sh ausführen
   └─ Exit Code muss 0 sein

6. DOKUMENTATION
   ├─ README.md aktualisieren (falls nötig)
   ├─ releaseNotes in umbrel-app.yml (falls Version ändert)
   └─ Änderungen dokumentieren

7. COMMIT & PUSH
   ├─ Conventional Commit Message
   ├─ "Closes #{issue-number}" in Message
   └─ Push zu Feature Branch

8. PULL REQUEST
   ├─ PR via gh CLI erstellen
   ├─ Template verwenden (Summary, Testing, Checklist)
   └─ Auto-Link zu Issue via "Closes #X"

9. ISSUE UPDATE
   ├─ Label "needs-review" hinzufügen
   └─ Status im Project Board aktualisieren
```

---

## 1️⃣ Task Auswahl

### Issue finden

```bash
# Alle verfügbaren Tasks anzeigen
gh issue list --label "ai-ready" --state open

# Nur kritische Tasks
gh issue list --label "ai-ready" --label "priority: critical"

# Tasks für spezifische App
gh issue list --label "ai-ready" --label "app: kasa-calcom"
```

### Prioritäts-Reihenfolge

1. **Priority: Critical** - Sicherheit & Stabilität (sofort)
2. **Priority: High** - Wichtige Verbesserungen (diese Woche)
3. **Priority: Medium** - Nice-to-have (nächste Woche)
4. **Priority: Low** - Zukunft (nach Phase 3)

### Issue auswählen

```bash
# Issue Details anzeigen
gh issue view {ISSUE_NUMBER}

# Wichtige Informationen:
# - Title & Description
# - Acceptance Criteria (Checkliste)
# - Files to Modify (welche Dateien)
# - AI Assistant Notes (spezielle Hinweise)
```

---

## 2️⃣ Branch Erstellen

### Branch Naming Convention

**Format:** `claude/optimization-{issue-num}-{kurze-beschreibung}-{session-id}`

**Beispiele:**
```bash
# Issue #1: Pin Docker versions
claude/optimization-1-pin-versions-JaPP1

# Issue #2: Add init true
claude/optimization-2-init-true-JaPP1

# Issue #3: Security hardening
claude/optimization-3-security-hardening-JaPP1
```

**WICHTIG:** Session-ID muss am Ende stehen (für git push)

### Branch erstellen

```bash
# Von main Branch starten
git checkout main
git pull origin main

# Feature Branch erstellen
git checkout -b claude/optimization-{issue-num}-{kurz}-{session}

# Beispiel:
git checkout -b claude/optimization-1-pin-versions-JaPP1
```

---

## 3️⃣ Kontext Sammeln

### Relevante Dateien lesen

```bash
# Lese IMMER diese Dateien zuerst:

# 1. Issue Template (hat alle Details)
cat .github/ISSUE_TEMPLATE/task-{X}-{Y}-{name}.md

# 2. Betroffene App-Dateien
cat apps/{app-id}/umbrel-app.yml
cat apps/{app-id}/docker-compose.yml
cat apps/{app-id}/README.md

# 3. CLAUDE.md (Repo Guidelines)
cat CLAUDE.md

# 4. Optimization Plan (Kontext)
cat docs/OPTIMIZATION_PLAN.md
```

### Bestehende Patterns verstehen

Wenn du eine Änderung an mehreren Apps vornimmst:

```bash
# Schau dir an, wie andere Apps es machen
# Beispiel: Security Hardening

# Referenz-Implementation lesen
cat apps/kasa-paperless-ai/docker-compose.yml

# Pattern identifizieren:
# - user: "1000:1000"
# - cap_drop: ALL
# - security_opt: no-new-privileges:true

# Dieses Pattern auf andere Apps anwenden
```

---

## 4️⃣ Implementierung

### Arbeitsverzeichnis

**✅ RICHTIG - Arbeite in `apps/` Verzeichnis:**
```bash
# IMMER hier arbeiten:
apps/kasa-azuracast/
apps/kasa-calcom/
apps/kasa-paperless-ai/
apps/kasa-paperless-gpt/
```

**❌ FALSCH - Nicht in root/ Verzeichnissen arbeiten:**
```bash
# NIEMALS hier editieren:
kasa-azuracast/      # ❌ Wird von publish.sh überschrieben!
kasa-calcom/         # ❌ Wird von publish.sh überschrieben!
kasa-paperless-ai/   # ❌ Wird von publish.sh überschrieben!
kasa-paperless-gpt/  # ❌ Wird von publish.sh überschrieben!
```

### Änderungen durchführen

**Verwende die Edit Tool für Änderungen:**

```bash
# Beispiel: Image Version pinnen

# 1. Datei lesen
cat apps/kasa-calcom/docker-compose.yml

# 2. Relevante Stelle identifizieren (z.B. Zeile 10)
# Zeile 10: image: ghcr.io/calcom/cal.com:latest

# 3. Edit Tool verwenden
# Replace: image: ghcr.io/calcom/cal.com:latest
# With:    image: ghcr.io/calcom/cal.com:v4.0.8
```

### Acceptance Criteria abarbeiten

**Behandle Acceptance Criteria als Checkliste:**

```markdown
## Acceptance Criteria
- [ ] Research latest stable versions
- [ ] Update docker-compose.yml
- [ ] Document version selection
- [ ] Test app starts successfully
- [ ] Update releaseNotes
- [ ] Run publish.sh
- [ ] Validation passes
```

**Arbeite jeden Punkt ab, bevor du fortfährst.**

---

## 5️⃣ Validierung

### Publish & Validate

```bash
# Schritt 1: Publiziere Änderungen zu root/
./scripts/publish.sh

# Output sollte zeigen:
# ✅ Published kasa-calcom/umbrel-app.yml
# ✅ Published kasa-calcom/docker-compose.yml
# ✅ Published kasa-calcom/README.md

# Schritt 2: Validiere alle Konfigurationen
./scripts/validate.sh

# Output sollte enden mit:
# ✅ All validations passed

# Schritt 3: Prüfe Exit Code
echo $?
# Sollte ausgeben: 0
```

### Fehlerbehandlung

**Wenn Validation fehlschlägt:**

```bash
# Häufige Fehler und Lösungen:

# Fehler: Port conflict detected
# Lösung: Ändere port: in umbrel-app.yml zu freiem Port

# Fehler: APP_PORT environment variable not found
# Lösung: Füge APP_PORT zu app_proxy environment hinzu

# Fehler: APP_HOST format incorrect
# Lösung: Format muss sein: {app-id}_{service-name}_1

# Fehler: YAML syntax error
# Lösung: Prüfe Einrückung (YAML ist whitespace-sensitiv)
```

**Validation wiederholen bis Exit Code 0:**

```bash
# Fehler beheben
# Dann erneut:
./scripts/publish.sh && ./scripts/validate.sh
```

---

## 6️⃣ Dokumentation

### README aktualisieren (wenn nötig)

**Wann README updaten:**
- Security-Änderungen (Capabilities, User)
- Neue Konfigurationsoptionen
- Geänderte Umgebungsvariablen
- Neue Dependencies

**Beispiel: Security Hardening**

```markdown
## Security

This app follows security hardening best practices:

- **Capabilities**: Drops all unnecessary Linux capabilities (`cap_drop: ALL`)
- **Privilege Escalation**: Prevents privilege escalation (`no-new-privileges:true`)
- **User**: Runs as non-root user (UID/GID 1000)

These restrictions minimize the attack surface and improve container isolation.
```

### umbrel-app.yml Release Notes (wenn nötig)

**Wann releaseNotes updaten:**
- Version Bump
- Breaking Changes
- Wichtige Verbesserungen

**Beispiel:**

```yaml
releaseNotes: >-
  Pinned Docker image to specific version for reproducible deployments.
  Using Cal.com v4.0.8.
```

---

## 7️⃣ Commit & Push

### Conventional Commit Message

**Format:** `type(scope): subject`

**Types:**
- `feat` - New feature or enhancement
- `fix` - Bug fix
- `chore` - Maintenance, updates
- `docs` - Documentation only
- `refactor` - Code restructuring

**Scopes:**
- `apps` - App-specific changes
- `scripts` - Script changes
- `docs` - Documentation

**Beispiel Commit Messages:**

```bash
# Beispiel 1: Pin versions
git commit -m "feat(apps): pin Docker image versions for stability

- kasa-calcom: ghcr.io/calcom/cal.com:v4.0.8
- kasa-paperless-ai: clusterzx/paperless-ai:v1.2.3
- kasa-paperless-gpt: icereed/paperless-gpt:v0.5.0

This change eliminates the reproducibility risk of :latest tags
and enables easier rollback if issues occur.

Closes #1"

# Beispiel 2: Add init true
git commit -m "fix(apps): add init: true to database services for graceful shutdown

- kasa-azuracast: Added to db and redis services
- kasa-calcom: Added to db and redis services

This ensures proper PID 1 signal handling and graceful shutdowns,
reducing the risk of database corruption during container stops.

Closes #2"

# Beispiel 3: Security hardening
git commit -m "feat(apps): apply security hardening across all apps

- Added cap_drop: ALL to application services
- Added no-new-privileges security option
- Configured non-root users where applicable

Following Paperless-AI security best practices pattern.
Reduces attack surface and improves container isolation.

Closes #3"
```

**WICHTIG:** `Closes #{issue-number}` am Ende verlinkt automatisch!

### Staging & Commit

```bash
# Änderte Dateien anzeigen
git status

# Nur relevante Apps stagen
git add apps/kasa-calcom apps/kasa-paperless-ai

# Optional: Diff prüfen vor Commit
git diff --staged

# Commit mit Message
git commit -m "feat(apps): pin Docker image versions

- kasa-calcom: v4.0.8
- kasa-paperless-ai: v1.2.3

Closes #1"
```

### Push zu Feature Branch

```bash
# Erster Push: Mit -u für upstream tracking
git push -u origin claude/optimization-{issue-num}-{kurz}-{session}

# Beispiel:
git push -u origin claude/optimization-1-pin-versions-JaPP1

# Weitere Pushes (falls nötig):
git push
```

**Git Push Retry bei Netzwerkfehlern:**

Laut CLAUDE.md: Bei Netzwerkfehlern bis zu 4x mit exponential backoff wiederholen (2s, 4s, 8s, 16s)

---

## 8️⃣ Pull Request Erstellen

### PR via GitHub CLI

```bash
gh pr create \
  --title "feat(apps): pin Docker image versions for stability" \
  --body "$(cat <<'EOF'
## Summary
Pins Docker images to specific versions for Cal.com, Paperless-AI, and Paperless-GPT.

## Changes
- Cal.com: ghcr.io/calcom/cal.com:v4.0.8
- Paperless-AI: clusterzx/paperless-ai:v1.2.3
- Paperless-GPT: icereed/paperless-gpt:v0.5.0

## Benefits
- Eliminates reproducibility risk of :latest tags
- Enables easier rollback if issues occur
- Predictable deployment behavior

## Testing
- [x] Validation passes: ./scripts/validate.sh
- [x] Apps start successfully (tested locally)
- [x] Version research documented in commit
- [x] Release notes updated

## Checklist
- [x] Edited in apps/ directory (not root)
- [x] Ran ./scripts/publish.sh
- [x] Ran ./scripts/validate.sh (exit 0)
- [x] Updated releaseNotes
- [x] No secrets committed

Closes #1
EOF
)"
```

### PR Template Struktur

```markdown
## Summary
[1-2 Sätze: Was wurde geändert]

## Changes
[Bullet-List der konkreten Änderungen]

## Benefits
[Warum ist diese Änderung gut?]

## Testing
- [x] Validation passes
- [x] Functionality tested
- [x] Documentation updated

## Checklist
- [x] Worked in apps/ directory
- [x] Ran publish.sh
- [x] Ran validate.sh
- [x] No secrets committed

Closes #{issue-number}
```

---

## 9️⃣ Issue Update

### Label hinzufügen

```bash
# Add "needs-review" Label
gh issue edit {ISSUE_NUMBER} --add-label "needs-review"

# Beispiel:
gh issue edit 1 --add-label "needs-review"
```

### Kommentar hinterlassen

```bash
# Optional: Kommentar mit PR Link
gh issue comment {ISSUE_NUMBER} --body "✅ Implementation complete. PR: #{PR_NUMBER}"
```

---

## 🔧 Troubleshooting

### Problem: Validation schlägt fehl

```bash
# Ausgabe von validate.sh prüfen
./scripts/validate.sh

# Häufige Fehler:

# ❌ Port conflict
# Symptom: "Port 3004 is used by multiple apps"
# Lösung: Ändere port: in umbrel-app.yml

# ❌ Missing APP_PORT
# Symptom: "APP_PORT not found in app_proxy"
# Lösung: Füge APP_PORT zu app_proxy environment hinzu

# ❌ Wrong APP_HOST format
# Symptom: "APP_HOST must match pattern"
# Lösung: Use {app-id}_{service-name}_1

# ❌ YAML syntax error
# Symptom: "YAML parse error"
# Lösung: Prüfe Einrückung (2 Spaces, keine Tabs)
```

### Problem: Git Push schlägt fehl (403)

```bash
# Fehler: HTTP 403
# Ursache: Branch Name folgt nicht Pattern

# ✅ RICHTIG:
claude/optimization-1-pin-versions-JaPP1
#     ^topic^           ^description^  ^session^

# ❌ FALSCH:
feature/pin-versions     # Fehlt claude/ prefix
claude/pin-versions      # Fehlt Session ID
optimization-1-JaPP1     # Fehlt claude/ prefix
```

### Problem: Änderungen nicht in root/ sichtbar

```bash
# Ursache: Du hast ./scripts/publish.sh vergessen!

# Lösung:
./scripts/publish.sh

# Jetzt sind apps/* → root/* synchronisiert

# Prüfe:
diff apps/kasa-calcom/docker-compose.yml kasa-calcom/docker-compose.yml
# Sollte keine Unterschiede zeigen
```

### Problem: App startet nicht nach Änderungen

```bash
# Test mit Docker Compose
docker compose -f apps/{app-id}/docker-compose.yml up -d

# Logs prüfen
docker compose -f apps/{app-id}/docker-compose.yml logs

# Häufige Probleme:

# ❌ Permission denied (nach Security Hardening)
# Lösung: Entferne user: "1000:1000" oder passe Berechtigungen an

# ❌ Operation not permitted (nach cap_drop)
# Lösung: Füge benötigte Capability hinzu:
#   cap_add:
#     - NET_BIND_SERVICE

# ❌ Database connection failed
# Lösung: Prüfe DATABASE_URL und APP_SEED Verwendung
```

---

## 📊 Best Practices

### ✅ DO

1. **Immer in apps/ arbeiten**
   ```bash
   nano apps/kasa-calcom/docker-compose.yml  # ✅
   nano kasa-calcom/docker-compose.yml       # ❌
   ```

2. **Immer publish.sh vor validate.sh**
   ```bash
   ./scripts/publish.sh && ./scripts/validate.sh  # ✅
   ```

3. **Acceptance Criteria als Checkliste**
   - Jeden Punkt einzeln abarbeiten
   - Nicht überspringen

4. **Kleine, fokussierte Changes**
   - Ein Issue = Ein logischer Change
   - Nicht mehrere Issues in einem PR

5. **Dokumentation mitpflegen**
   - README bei Verhaltensänderungen
   - releaseNotes bei Versions-Bumps

### ❌ DON'T

1. **Nicht root/ direkt editieren**
   - publish.sh überschreibt diese!

2. **Nicht ohne Validation committen**
   - Könnte andere Tasks blockieren

3. **Nicht over-engineeren**
   - Nur was im Issue steht
   - Keine "improvements" ohne Issue

4. **Nicht Secrets committen**
   - Immer git diff vor Commit prüfen

5. **Nicht raten bei Versionen**
   - Recherchiere tatsächliche stabile Versionen
   - Teste dass Version existiert

---

## 🎯 Quick Reference

### Essential Commands

```bash
# 1. Task wählen
gh issue list --label "ai-ready"

# 2. Branch erstellen
git checkout -b claude/optimization-{num}-{desc}-{session}

# 3. Dateien lesen
cat apps/{app-id}/docker-compose.yml
cat .github/ISSUE_TEMPLATE/task-{X}-{Y}.md

# 4. Änderungen durchführen
# (Use Edit tool)

# 5. Validieren
./scripts/publish.sh && ./scripts/validate.sh

# 6. Commit
git add apps/{app-id}
git commit -m "type(scope): subject

Details...

Closes #{issue-num}"

# 7. Push
git push -u origin claude/optimization-{num}-{desc}-{session}

# 8. PR erstellen
gh pr create --title "..." --body "..."

# 9. Label hinzufügen
gh issue edit {num} --add-label "needs-review"
```

### Critical Rules

1. ✅ Work in `apps/` only (never in root app dirs)
2. ✅ Run `publish.sh` before `validate.sh`
3. ✅ Validate must exit with code 0
4. ✅ Branch name: `claude/*-{session-id}`
5. ✅ Link issue: `Closes #{number}`
6. ✅ Follow Acceptance Criteria exactly
7. ✅ Document changes in README if behavior changes
8. ✅ No secrets in commits

---

## 📚 Weitere Ressourcen

- **Hauptdokumentation:** `CLAUDE.md` (Repo-spezifische Guidelines)
- **Optimierungsplan:** `docs/OPTIMIZATION_PLAN.md` (Gesamtstrategie)
- **Entwickler-Workflow:** `DEVELOPMENT.md` (Allgemeine Entwicklung)
- **Issue Templates:** `.github/ISSUE_TEMPLATE/` (Task Details)

---

## ✅ Erfolg!

Wenn du diese Schritte befolgst, kannst du systematisch Issues abarbeiten und zur Optimierung des Kasa Community App Store beitragen.

**Bei Fragen:**
- Prüfe CLAUDE.md
- Prüfe Issue Template
- Prüfe OPTIMIZATION_PLAN.md
- Kommentiere im Issue auf GitHub

**Viel Erfolg! 🚀**

---

**Version:** 1.0.0
**Erstellt:** 2026-01-08
**Zuletzt aktualisiert:** 2026-01-08
