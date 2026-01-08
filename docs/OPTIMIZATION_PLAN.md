# umbrelOS 1.5 App Optimization Plan
# Kasa Community App Store - Systematic Improvement Strategy

> **Status**: Planning Phase
> **Created**: 2026-01-08
> **Target Completion**: Rolling implementation
> **Responsible**: AI Assistants (Claude Code, ChatGPT Codex, etc.)

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Optimization Goals](#optimization-goals)
3. [GitHub Workflow Strategy](#github-workflow-strategy)
4. [Optimization Phases](#optimization-phases)
5. [Detailed Task Breakdown](#detailed-task-breakdown)
6. [AI Assistant Workflow](#ai-assistant-workflow)
7. [Success Metrics](#success-metrics)
8. [Implementation Timeline](#implementation-timeline)

---

## Executive Summary

### Current State

Die Kasa Community App Store hat 4 aktive Apps mit solider Grundstruktur:
- ✅ Korrekte Dual-Location-Architektur (apps/ ↔ root/)
- ✅ Konsistente Port-Verwaltung (3001-3004)
- ✅ Funktionierende Docker Compose Konfigurationen
- ⚠️ Verbesserungspotenzial: Sicherheit, Versionierung, Konsistenz

### Optimization Scope

**Apps to Optimize:**
1. `kasa-azuracast` - Radio streaming platform
2. `kasa-calcom` - Open-source scheduling
3. `kasa-paperless-ai` - AI document tagging
4. `kasa-paperless-gpt` - LLM-powered OCR

**Key Improvements:**
- Security hardening (capabilities, non-root users)
- Image version pinning (eliminate `:latest` tags)
- Consistent volume organization
- Enhanced documentation
- umbrelOS 1.5 compliance

---

## Optimization Goals

### Primary Goals (Must-Have)

#### 1. Security Enhancement
**Current Issue:** Nur 1 von 4 Apps nutzt Security Hardening
**Target:** Alle Apps mit `cap_drop`, `no-new-privileges`, non-root user

**Benefits:**
- Reduced attack surface
- Better container isolation
- Compliance with security best practices

#### 2. Version Stability
**Current Issue:** 75% der Apps nutzen `:latest` Tags
**Target:** Alle Apps mit gepinnten, spezifischen Versionen

**Benefits:**
- Reproducible deployments
- Easier rollback capabilities
- Predictable behavior

#### 3. Signal Handling
**Current Issue:** Database/Redis Services fehlt `init: true`
**Target:** Alle Services mit korrektem PID 1 Handling

**Benefits:**
- Graceful shutdowns
- Proper signal propagation
- Reduced data corruption risk

### Secondary Goals (Should-Have)

#### 4. Configuration Consistency
**Current Issue:** Inkonsistente Volume-Pfad-Strukturen
**Target:** Einheitliches Pattern für alle Apps

**Benefits:**
- Easier maintenance
- Clearer debugging
- Better user understanding

#### 5. Documentation Clarity
**Current Issue:** Manuelle Konfigurationsschritte unklar dokumentiert
**Target:** Step-by-step Setup Guides für alle Apps

**Benefits:**
- Better user onboarding
- Reduced support requests
- Clearer dependency management

### Tertiary Goals (Nice-to-Have)

#### 6. Health Checks
**Target:** Implementierung von Docker Health Checks

#### 7. Resource Limits
**Target:** CPU/Memory Limits für alle Services

#### 8. umbrelOS 1.5 Specific Features
**Target:** GPU passthrough support (where applicable)

---

## GitHub Workflow Strategy

### Overview

Wir nutzen GitHub Issues + Projects für systematisches Task Management:

```
┌─────────────────────────────────────────────────────────┐
│                    GitHub Project Board                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Backlog  │  Ready  │  In Progress  │  Review  │  Done  │
│     │          │           │             │         │     │
│  Issues   →  Issues  →   Issues    →  Issues  →  Issues │
│                                                          │
└─────────────────────────────────────────────────────────┘
         ↓
    AI Assistant picks next task from "Ready"
         ↓
    Creates feature branch: claude/optimization-{task-id}-{short-desc}
         ↓
    Implements changes following CLAUDE.md guidelines
         ↓
    Runs validation: ./scripts/publish.sh && ./scripts/validate.sh
         ↓
    Commits with conventional commit message
         ↓
    Pushes to feature branch
         ↓
    Opens Pull Request (auto-linked to Issue)
         ↓
    Moves Issue to "Review" column
```

### GitHub Project Structure

**Project Name:** `umbrelOS 1.5 Optimization`

**Columns:**
1. **Backlog** - All planned tasks
2. **Ready** - Tasks ready for implementation (dependencies met)
3. **In Progress** - Currently being worked on
4. **Review** - PR opened, awaiting review
5. **Done** - Merged and closed

**Labels:**
- `priority: critical` - Security/stability issues
- `priority: high` - Important improvements
- `priority: medium` - Nice-to-have enhancements
- `priority: low` - Future improvements
- `type: security` - Security-related changes
- `type: config` - Configuration improvements
- `type: docs` - Documentation updates
- `type: refactor` - Code refactoring
- `app: kasa-azuracast` - App-specific
- `app: kasa-calcom` - App-specific
- `app: kasa-paperless-ai` - App-specific
- `app: kasa-paperless-gpt` - App-specific
- `scope: all-apps` - Affects all apps
- `ai-ready` - Ready for AI assistant to pick up
- `blocked` - Blocked by dependency or external factor

### Issue Template Structure

Each task wird als GitHub Issue erstellt mit folgendem Format:

```markdown
## Task Description
[Clear, concise description of what needs to be done]

## Current State
[What exists now - reference files/lines]

## Target State
[What should exist after completion]

## Acceptance Criteria
- [ ] Specific, testable requirement 1
- [ ] Specific, testable requirement 2
- [ ] Validation passes: `./scripts/validate.sh`
- [ ] Documentation updated

## Files to Modify
- `apps/{app-id}/docker-compose.yml`
- `apps/{app-id}/README.md`

## Related Issues
- Depends on: #X
- Blocks: #Y

## AI Assistant Notes
[Specific guidance for AI implementation]
```

---

## Optimization Phases

### Phase 1: Critical Security & Stability (Week 1-2)
**Goal:** Eliminate high-risk issues

**Tasks:**
1. Pin all Docker image versions
2. Add `init: true` to database services
3. Implement security hardening (cap_drop, security_opt, user)
4. Fix hardcoded credentials in Paperless-GPT

**Success Criteria:**
- ✅ No `:latest` tags in production
- ✅ All services have proper signal handling
- ✅ All apps run with minimal capabilities
- ✅ No hardcoded placeholders requiring manual edits

### Phase 2: Configuration Consistency (Week 3-4)
**Goal:** Standardize patterns across apps

**Tasks:**
1. Standardize volume path organization
2. Consolidate duplicate environment variables
3. Implement consistent naming conventions
4. Add missing dependency declarations

**Success Criteria:**
- ✅ All apps use same volume pattern
- ✅ No duplicate configurations
- ✅ Dependencies clearly documented

### Phase 3: Documentation Enhancement (Week 5-6)
**Goal:** Improve user experience

**Tasks:**
1. Add "First Run Setup" guides
2. Document dependency requirements (Ollama, Paperless-ngx)
3. Clarify credential management
4. Add troubleshooting sections

**Success Criteria:**
- ✅ Clear setup instructions for all apps
- ✅ External dependencies documented
- ✅ Common issues addressed

### Phase 4: Advanced Optimizations (Week 7+)
**Goal:** Add production-ready features

**Tasks:**
1. Implement health checks
2. Add resource limits (CPU/memory)
3. Configure logging
4. Add backup/restore documentation
5. umbrelOS 1.5 specific features (GPU passthrough)

**Success Criteria:**
- ✅ Health checks on critical services
- ✅ Resource usage optimized
- ✅ Production monitoring ready

---

## Detailed Task Breakdown

### Phase 1 Tasks (Critical)

#### Task 1.1: Pin Docker Image Versions
**Issue Title:** `[Security] Pin Docker image versions for all apps`
**Labels:** `priority: critical`, `type: security`, `scope: all-apps`, `ai-ready`
**Estimate:** 2 hours

**Acceptance Criteria:**
- [ ] Research latest stable versions for:
  - Cal.com: `ghcr.io/calcom/cal.com`
  - Paperless-AI: `clusterzx/paperless-ai`
  - Paperless-GPT: `icereed/paperless-gpt`
- [ ] Update `docker-compose.yml` for each app
- [ ] Document version selection rationale in commit message
- [ ] Test each app starts successfully with pinned version
- [ ] Update `releaseNotes` in `umbrel-app.yml`

**Files to Modify:**
```
apps/kasa-calcom/docker-compose.yml (line 10)
apps/kasa-paperless-ai/docker-compose.yml (line 10)
apps/kasa-paperless-gpt/docker-compose.yml (line 10)
apps/kasa-calcom/umbrel-app.yml (version, releaseNotes)
apps/kasa-paperless-ai/umbrel-app.yml (releaseNotes)
apps/kasa-paperless-gpt/umbrel-app.yml (releaseNotes)
```

**AI Implementation Steps:**
```bash
# 1. Research current stable versions
# Check Docker Hub/GHCR for each image
# Document findings in commit message

# 2. Update docker-compose.yml files
# Replace :latest with specific version tag

# 3. Publish and validate
./scripts/publish.sh
./scripts/validate.sh

# 4. Commit
git add apps/kasa-calcom apps/kasa-paperless-ai apps/kasa-paperless-gpt
git commit -m "feat(apps): pin Docker image versions for stability

- kasa-calcom: ghcr.io/calcom/cal.com:v4.x.x
- kasa-paperless-ai: clusterzx/paperless-ai:vX.X.X
- kasa-paperless-gpt: icereed/paperless-gpt:vX.X.X

This change eliminates the reproducibility risk of :latest tags
and enables easier rollback if issues occur."
```

---

#### Task 1.2: Add init: true to Database Services
**Issue Title:** `[Stability] Add init: true to database and cache services`
**Labels:** `priority: critical`, `type: config`, `app: kasa-azuracast`, `app: kasa-calcom`, `ai-ready`
**Estimate:** 1 hour

**Acceptance Criteria:**
- [ ] Add `init: true` to AzuraCast db service
- [ ] Add `init: true` to AzuraCast redis service
- [ ] Add `init: true` to Cal.com db service
- [ ] Add `init: true` to Cal.com redis service
- [ ] Verify proper signal handling in documentation
- [ ] Update README if signal handling is mentioned

**Files to Modify:**
```
apps/kasa-azuracast/docker-compose.yml (db, redis services)
apps/kasa-calcom/docker-compose.yml (db, redis services)
```

**AI Implementation Steps:**
```bash
# 1. Edit docker-compose.yml files
# Add init: true to db and redis services

# 2. Publish and validate
./scripts/publish.sh
./scripts/validate.sh

# 3. Commit
git add apps/kasa-azuracast apps/kasa-calcom
git commit -m "fix(apps): add init: true to database services for graceful shutdown

- kasa-azuracast: Added to db and redis services
- kasa-calcom: Added to db and redis services

This ensures proper PID 1 signal handling and graceful shutdowns."
```

---

#### Task 1.3: Apply Security Hardening
**Issue Title:** `[Security] Apply security hardening to non-hardened apps`
**Labels:** `priority: high`, `type: security`, `scope: all-apps`, `ai-ready`
**Estimate:** 3 hours

**Acceptance Criteria:**
- [ ] Add `cap_drop: ALL` to suitable services
- [ ] Add `security_opt: no-new-privileges=true`
- [ ] Configure non-root user where possible
- [ ] Document security changes in README
- [ ] Test apps still function correctly
- [ ] Consider service-specific requirements (databases may need specific caps)

**Files to Modify:**
```
apps/kasa-azuracast/docker-compose.yml (web, stations services)
apps/kasa-calcom/docker-compose.yml (server service)
apps/kasa-paperless-gpt/docker-compose.yml (server service)
apps/*/README.md (security notes)
```

**AI Implementation Steps:**
```bash
# 1. Review kasa-paperless-ai/docker-compose.yml as reference
# Understand security pattern:
# - cap_drop: ALL
# - security_opt: no-new-privileges=true
# - user: "1000:1000"

# 2. Apply to each app's main service
# Be careful: databases may need specific capabilities

# 3. Test each app
# Ensure no functionality breaks

# 4. Document changes in README

# 5. Publish and validate
./scripts/publish.sh
./scripts/validate.sh

# 6. Commit
git commit -m "feat(apps): apply security hardening across all apps

- Added cap_drop: ALL to application services
- Added no-new-privileges security option
- Configured non-root users where applicable

Following Paperless-AI security best practices pattern."
```

---

#### Task 1.4: Fix Hardcoded Credentials
**Issue Title:** `[Config] Replace CHANGE_ME placeholder with APP_SEED in Paperless-GPT`
**Labels:** `priority: high`, `type: config`, `app: kasa-paperless-gpt`, `ai-ready`
**Estimate:** 1 hour

**Acceptance Criteria:**
- [ ] Evaluate if `PAPERLESS_API_TOKEN` can use `${APP_SEED}`
- [ ] If yes: Update docker-compose.yml
- [ ] If no: Add clear documentation with setup steps
- [ ] Add "First Run Setup" section to README
- [ ] Document token generation process

**Files to Modify:**
```
apps/kasa-paperless-gpt/docker-compose.yml (PAPERLESS_API_TOKEN)
apps/kasa-paperless-gpt/README.md (setup instructions)
```

**AI Implementation Steps:**
```bash
# 1. Research Paperless-ngx API token requirements
# Determine if token must be from Paperless or can be arbitrary

# 2. If arbitrary token works:
# Change PAPERLESS_API_TOKEN: "CHANGE_ME" to "${APP_SEED}"

# 3. If must be from Paperless:
# Add clear setup instructions in README

# 4. Publish and validate
./scripts/publish.sh
./scripts/validate.sh

# 5. Commit
```

---

### Phase 2 Tasks (Consistency)

#### Task 2.1: Standardize Volume Organization
**Issue Title:** `[Refactor] Standardize volume path organization across all apps`
**Labels:** `priority: medium`, `type: refactor`, `scope: all-apps`, `ai-ready`
**Estimate:** 2 hours

**Target Pattern:**
```yaml
volumes:
  - ${APP_DATA_DIR}/app:/app/data      # Application data
  - ${APP_DATA_DIR}/db:/var/lib/db     # Database data
  - ${APP_DATA_DIR}/cache:/cache       # Cache data
```

**Acceptance Criteria:**
- [ ] Define standard volume pattern
- [ ] Document pattern in CLAUDE.md
- [ ] Apply to all apps consistently
- [ ] Update README volume documentation
- [ ] Consider migration path (data preservation)

**Files to Modify:**
```
All apps/*/docker-compose.yml
All apps/*/README.md
CLAUDE.md (add standard pattern)
```

---

#### Task 2.2: Consolidate Duplicate Environment Variables
**Issue Title:** `[Refactor] Remove duplicate environment variables in AzuraCast`
**Labels:** `priority: low`, `type: refactor`, `app: kasa-azuracast`, `ai-ready`
**Estimate:** 1 hour

**Current Issue:** Lines 40-49 duplicate lines 19-25 in docker-compose.yml

**Acceptance Criteria:**
- [ ] Identify all duplicate variables
- [ ] Determine if both services need same config
- [ ] Use shared environment or document why duplicated
- [ ] Test AzuraCast functionality

**Files to Modify:**
```
apps/kasa-azuracast/docker-compose.yml
```

---

### Phase 3 Tasks (Documentation)

#### Task 3.1: Add First Run Setup Guides
**Issue Title:** `[Docs] Add First Run Setup section to all app READMEs`
**Labels:** `priority: medium`, `type: docs`, `scope: all-apps`, `ai-ready`
**Estimate:** 2 hours

**Template:**
```markdown
## First Run Setup

### Prerequisites
- [ ] Umbrel OS 1.5 or later
- [ ] [App-specific dependencies]

### Installation Steps
1. Install from Kasa Community App Store
2. Access at `http://umbrel.local:{PORT}`
3. [App-specific setup steps]

### Initial Configuration
- **Username**: [Default or how to set]
- **Password**: [Default or how to set]
- **Required Settings**: [Critical config items]

### Troubleshooting
- Issue: [Common problem]
  - Solution: [How to fix]
```

**Files to Modify:**
```
apps/kasa-azuracast/README.md
apps/kasa-calcom/README.md
apps/kasa-paperless-ai/README.md
apps/kasa-paperless-gpt/README.md
```

---

#### Task 3.2: Document External Dependencies
**Issue Title:** `[Docs] Document all external app dependencies (Ollama, Paperless-ngx)`
**Labels:** `priority: high`, `type: docs`, `app: kasa-paperless-gpt`, `app: kasa-paperless-ai`, `ai-ready`
**Estimate:** 1.5 hours

**Acceptance Criteria:**
- [ ] Document Ollama requirement for Paperless-GPT
- [ ] Document Paperless-ngx requirement for both Paperless apps
- [ ] Add installation links for dependencies
- [ ] Update `umbrel-app.yml` dependencies field (if supported)
- [ ] Add dependency check instructions

**Files to Modify:**
```
apps/kasa-paperless-gpt/README.md
apps/kasa-paperless-gpt/umbrel-app.yml
apps/kasa-paperless-ai/README.md
apps/kasa-paperless-ai/umbrel-app.yml
```

---

#### Task 3.3: Clarify Credential Management
**Issue Title:** `[Docs] Add credential management documentation for all apps`
**Labels:** `priority: medium`, `type: docs`, `scope: all-apps`, `ai-ready`
**Estimate:** 1.5 hours

**Template Section:**
```markdown
## Security & Credentials

### Database Credentials
This app uses Umbrel's `APP_SEED` environment variable to generate
secure, unique database credentials automatically. You do not need
to configure database passwords manually.

### Changing Credentials
To regenerate app credentials:
1. [App-specific steps]
2. Restart the app from Umbrel dashboard

### API Keys & Tokens
[Document any external API keys needed]
```

**Files to Modify:**
```
apps/kasa-azuracast/README.md
apps/kasa-calcom/README.md
apps/kasa-paperless-ai/README.md
apps/kasa-paperless-gpt/README.md
```

---

### Phase 4 Tasks (Advanced)

#### Task 4.1: Implement Health Checks
**Issue Title:** `[Enhancement] Add Docker health checks to all services`
**Labels:** `priority: low`, `type: enhancement`, `scope: all-apps`, `ai-ready`
**Estimate:** 3 hours

**Template:**
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:{PORT}/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

**Acceptance Criteria:**
- [ ] Research health check endpoints for each app
- [ ] Implement health checks for main services
- [ ] Test health check behavior (startup, running, failure)
- [ ] Document health check configuration

**Files to Modify:**
```
All apps/*/docker-compose.yml
```

---

#### Task 4.2: Add Resource Limits
**Issue Title:** `[Enhancement] Configure CPU and memory limits for all services`
**Labels:** `priority: low`, `type: enhancement`, `scope: all-apps`, `ai-ready`
**Estimate:** 2 hours

**Recommended Limits:**
- AzuraCast: 2 CPUs, 4GB RAM (streaming workload)
- Cal.com: 1 CPU, 2GB RAM (web application)
- Paperless-AI: 1 CPU, 1GB RAM (lightweight)
- Paperless-GPT: 1 CPU, 2GB RAM (LLM interaction)

**Template:**
```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 2G
    reservations:
      cpus: '0.5'
      memory: 512M
```

**Files to Modify:**
```
All apps/*/docker-compose.yml
All apps/*/README.md (resource requirements)
```

---

#### Task 4.3: umbrelOS 1.5 GPU Passthrough Support
**Issue Title:** `[Enhancement] Add GPU passthrough support for AI apps`
**Labels:** `priority: low`, `type: enhancement`, `app: kasa-paperless-ai`, `app: kasa-paperless-gpt`, `ai-ready`
**Estimate:** 3 hours

**Relevant Apps:** Paperless-AI, Paperless-GPT (AI/LLM workloads)

**Acceptance Criteria:**
- [ ] Research umbrelOS 1.5 GPU passthrough syntax
- [ ] Add optional GPU configuration
- [ ] Document GPU requirements
- [ ] Test with and without GPU

**Files to Modify:**
```
apps/kasa-paperless-ai/docker-compose.yml
apps/kasa-paperless-gpt/docker-compose.yml
apps/*/README.md (GPU documentation)
```

---

## AI Assistant Workflow

### Workflow für Claude Code / ChatGPT Codex

#### 1. Task Selection
```bash
# AI Assistant prüft GitHub Project Board
# Wählt Task aus "Ready" Column mit "ai-ready" Label
# Erstellt Feature Branch
git checkout -b claude/optimization-{issue-number}-{short-description}
```

#### 2. Context Gathering
```bash
# Liest relevante Dateien
cat apps/{app-id}/umbrel-app.yml
cat apps/{app-id}/docker-compose.yml
cat apps/{app-id}/README.md

# Liest Issue Details von GitHub
# Versteht Acceptance Criteria
# Identifiziert Files to Modify
```

#### 3. Implementation
```bash
# Folgt CLAUDE.md Guidelines:
# 1. IMMER in apps/{app-id}/ arbeiten (NICHT root!)
# 2. Änderungen gemäß Acceptance Criteria
# 3. Keine Over-Engineering
# 4. Security Best Practices befolgen

# Beispiel: Image Version pinnen
# Edit apps/kasa-calcom/docker-compose.yml
# Change: image: ghcr.io/calcom/cal.com:latest
# To:     image: ghcr.io/calcom/cal.com:v4.0.8
```

#### 4. Validation
```bash
# Publiziere Änderungen zu Root
./scripts/publish.sh

# Validiere alle Requirements
./scripts/validate.sh

# Exit Code muss 0 sein!
```

#### 5. Documentation
```bash
# Update README wenn nötig
# Dokumentiere Breaking Changes
# Update releaseNotes in umbrel-app.yml
```

#### 6. Commit & Push
```bash
# Git Hook generiert Commit Message automatisch
git add apps/{app-id}
git commit  # Message wird automatisch generiert

# Alternative: Manuelle Message (Conventional Commits)
git commit -m "feat(apps): pin Docker image version for kasa-calcom

- Updated to ghcr.io/calcom/cal.com:v4.0.8
- Eliminates reproducibility risk of :latest tag
- Enables easier rollback if issues occur

Closes #123"

# Push zu Feature Branch
git push -u origin claude/optimization-{issue-number}-{short-desc}
```

#### 7. Pull Request Creation
```bash
# Erstelle PR via GitHub CLI
gh pr create --title "feat(apps): pin Docker image version for kasa-calcom" \
  --body "$(cat <<'EOF'
## Summary
- Pinned Cal.com Docker image to specific version v4.0.8
- Updated docker-compose.yml and umbrel-app.yml
- Validated with ./scripts/validate.sh

## Related Issue
Closes #123

## Testing
- [x] Validation passes
- [x] App starts successfully
- [x] Documentation updated

## Checklist
- [x] Edited in apps/ directory (not root)
- [x] Ran ./scripts/publish.sh
- [x] Ran ./scripts/validate.sh (exit 0)
- [x] Updated releaseNotes if version changed
- [x] No secrets committed
EOF
)"

# PR wird automatisch mit Issue #123 verlinkt (via "Closes #123")
```

#### 8. Issue Management
```bash
# GitHub Actions oder manuell:
# - Issue Status → "Review"
# - Add Label: "needs-review"
# - Assign Reviewer (optional)

# Nach Merge:
# - Issue Status → "Done"
# - Issue wird automatisch geschlossen (Closes #123)
```

---

### AI Assistant Best Practices

#### ✅ DO

1. **Immer in `apps/` arbeiten**
   ```bash
   # ✅ RICHTIG
   nano apps/kasa-calcom/docker-compose.yml

   # ❌ FALSCH
   nano kasa-calcom/docker-compose.yml
   ```

2. **Immer validieren vor Commit**
   ```bash
   ./scripts/publish.sh && ./scripts/validate.sh
   ```

3. **Acceptance Criteria als Checkliste**
   - Jedes Item muss erfüllt sein
   - Bei Unklarheit: Frage im Issue kommentieren

4. **Kleine, fokussierte Änderungen**
   - Ein Issue = Ein logischer Change
   - Nicht mehrere Issues in einem PR

5. **Dokumentation mitpflegen**
   - README updates wenn Behavior ändert
   - releaseNotes in umbrel-app.yml

#### ❌ DON'T

1. **Nicht root/ Verzeichnisse direkt editieren**
   - publish.sh überschreibt diese!

2. **Nicht mehrere Apps in einem PR**
   - Exception: scope: all-apps Tasks

3. **Nicht ohne Validation committen**
   - Kann andere Tasks blockieren

4. **Nicht over-engineeren**
   - Nur was im Issue gefordert ist
   - Keine "improvements" ohne Issue

5. **Nicht Secrets committen**
   - Check vor Commit: `git diff`

---

### Troubleshooting für AI Assistants

#### Problem: Validation schlägt fehl
```bash
# Prüfe Output von validate.sh
./scripts/validate.sh

# Häufige Fehler:
# - Port Konflikt → Ändere port in umbrel-app.yml
# - Fehlende APP_PORT → Add zu app_proxy environment
# - Falsches APP_HOST Format → Use {app-id}_{service}_1
# - YAML Syntax Error → Prüfe Einrückung
```

#### Problem: Git Push schlägt fehl (403)
```bash
# Branch muss claude/* Pattern folgen UND Session ID enthalten
# Beispiel: claude/optimization-123-pin-versions-JaPP1
#                    ^feature name^        ^session^
```

#### Problem: Changes nicht in root/ sichtbar
```bash
# Du hast vergessen zu publishen!
./scripts/publish.sh

# Jetzt sind apps/* → root/* synchronisiert
```

---

## Success Metrics

### Quantitative Metrics

| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|
| Apps with pinned versions | 25% (1/4) | 100% (4/4) | Count of `:latest` tags |
| Apps with security hardening | 25% (1/4) | 100% (4/4) | cap_drop + security_opt |
| Services with init: true | 40% (4/10) | 100% (10/10) | Count per service type |
| Apps with clear setup docs | 50% (2/4) | 100% (4/4) | README completeness score |
| Validation pass rate | 100% | 100% | ./scripts/validate.sh exit code |

### Qualitative Metrics

- **User Onboarding Time:** Reduced from "unclear" to "< 5 minutes per app"
- **Deployment Reliability:** Reproducible builds, no `:latest` surprises
- **Security Posture:** All apps follow principle of least privilege
- **Maintenance Burden:** Consistent patterns = easier updates

### Phase Completion Criteria

#### Phase 1 Complete When:
- ✅ All critical security issues resolved
- ✅ Zero `:latest` tags in production
- ✅ All services properly initialized
- ✅ No hardcoded credential placeholders

#### Phase 2 Complete When:
- ✅ Volume paths follow consistent pattern
- ✅ No duplicate environment variables
- ✅ Dependencies clearly documented

#### Phase 3 Complete When:
- ✅ Every app has "First Run Setup" section
- ✅ External dependencies documented with links
- ✅ Credential management explained

#### Phase 4 Complete When:
- ✅ Health checks implemented and tested
- ✅ Resource limits configured appropriately
- ✅ umbrelOS 1.5 features documented

---

## Implementation Timeline

### Recommended Approach

**Strategy:** Rolling implementation, one phase at a time

```
Week 1-2:  Phase 1 (Critical Security & Stability)
           ├── Task 1.1: Pin versions (all apps)
           ├── Task 1.2: Add init: true (AzuraCast, Cal.com)
           ├── Task 1.3: Security hardening (3 apps)
           └── Task 1.4: Fix CHANGE_ME (Paperless-GPT)

Week 3-4:  Phase 2 (Configuration Consistency)
           ├── Task 2.1: Standardize volumes (all apps)
           └── Task 2.2: Consolidate env vars (AzuraCast)

Week 5-6:  Phase 3 (Documentation Enhancement)
           ├── Task 3.1: First Run Setup guides (all apps)
           ├── Task 3.2: External dependencies (2 apps)
           └── Task 3.3: Credential management (all apps)

Week 7+:   Phase 4 (Advanced Optimizations)
           ├── Task 4.1: Health checks (all apps)
           ├── Task 4.2: Resource limits (all apps)
           └── Task 4.3: GPU passthrough (2 apps)
```

### Parallel Execution Strategy

**For AI Assistant Teams:**

If multiple AI assistants arbeiten parallel:

```
Assistant 1: Phase 1, Apps 1-2 (AzuraCast, Cal.com)
Assistant 2: Phase 1, Apps 3-4 (Paperless-AI, Paperless-GPT)

Assistant 1: Phase 2, All apps (after Phase 1 merge)
Assistant 2: Phase 3, Documentation (can start earlier)

Assistant 1: Phase 4, Infrastructure tasks
Assistant 2: Phase 4, App-specific enhancements
```

**Branch Naming:**
```
claude/optimization-p1-azuracast-security-JaPP1
claude/optimization-p1-calcom-security-JaPP1
claude/optimization-p1-paperless-versions-JaPP1
```

### Dependency Graph

```
Task 1.1 (Pin Versions) ─┐
                          ├─→ Task 1.3 (Security)
Task 1.2 (Init: true) ────┘

Task 1.4 (Fix CHANGE_ME) ──→ Task 3.1 (Setup Guides)

Task 2.1 (Volume Std.) ────→ Task 4.2 (Resource Limits)

Task 3.2 (Dependencies) ───→ Task 4.3 (GPU Passthrough)
```

**Critical Path:** Task 1.1 → Task 1.3 → Task 2.1 → Task 4.2

---

## Appendix

### A. GitHub Project Setup Commands

```bash
# Create GitHub Project (via gh CLI)
gh project create --title "umbrelOS 1.5 Optimization" \
  --body "Systematic improvement of Kasa Community App Store apps"

# Create Labels
gh label create "priority: critical" --color "d73a4a" --description "Critical security/stability"
gh label create "priority: high" --color "ff6b6b" --description "Important improvements"
gh label create "priority: medium" --color "fbca04" --description "Nice-to-have enhancements"
gh label create "priority: low" --color "0e8a16" --description "Future improvements"
gh label create "type: security" --color "b60205" --description "Security-related"
gh label create "type: config" --color "1d76db" --description "Configuration"
gh label create "type: docs" --color "0075ca" --description "Documentation"
gh label create "type: refactor" --color "5319e7" --description "Refactoring"
gh label create "app: kasa-azuracast" --color "e99695"
gh label create "app: kasa-calcom" --color "f9d0c4"
gh label create "app: kasa-paperless-ai" --color "c2e0c6"
gh label create "app: kasa-paperless-gpt" --color "bfdadc"
gh label create "scope: all-apps" --color "fef2c0" --description "Affects all apps"
gh label create "ai-ready" --color "7057ff" --description "Ready for AI assistant"
gh label create "blocked" --color "d93f0b" --description "Blocked"
```

### B. Issue Creation Template Script

```bash
#!/bin/bash
# scripts/create-optimization-issues.sh

# Task 1.1: Pin versions
gh issue create \
  --title "[Security] Pin Docker image versions for all apps" \
  --label "priority: critical,type: security,scope: all-apps,ai-ready" \
  --body-file .github/ISSUE_TEMPLATE/task-1-1-pin-versions.md

# Task 1.2: Init true
gh issue create \
  --title "[Stability] Add init: true to database and cache services" \
  --label "priority: critical,type: config,app: kasa-azuracast,app: kasa-calcom,ai-ready" \
  --body-file .github/ISSUE_TEMPLATE/task-1-2-init-true.md

# ... (mehr Issues)
```

### C. Quick Reference for AI Assistants

**Essential Commands:**
```bash
# Start Task
git checkout -b claude/optimization-{issue}-{desc}-{session}

# Work
nano apps/{app-id}/{file}

# Validate
./scripts/publish.sh && ./scripts/validate.sh

# Commit
git add apps/{app-id}
git commit -m "feat(apps): {description}

Closes #{issue-number}"

# Push
git push -u origin claude/optimization-{issue}-{desc}-{session}

# PR
gh pr create --title "{title}" --body "{body}"
```

**Critical Rules:**
1. ✅ Work in `apps/` only
2. ✅ Run `publish.sh` before commit
3. ✅ Run `validate.sh` before commit
4. ✅ Follow branch naming: `claude/*-{session}`
5. ✅ Link to issue: `Closes #{number}`

---

## Document Revision History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-01-08 | Initial optimization plan created | Claude Code |

---

**Next Steps:**

1. Review this plan
2. Create GitHub Project Board
3. Create GitHub Issues from task breakdown
4. Assign first batch of tasks to "Ready" column
5. Begin Phase 1 implementation

**Questions? Issues?**
Open a GitHub Discussion or Issue in this repository.

---

**End of Optimization Plan**
