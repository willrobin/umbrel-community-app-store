---
name: Pin Docker Image Versions
about: Pin Docker image versions for all apps to eliminate :latest tags
title: '[Security] Pin Docker image versions for all apps'
labels: 'priority: critical, type: security, scope: all-apps, ai-ready'
assignees: ''
---

## Task Description

Replace all `:latest` Docker image tags with pinned, specific versions to ensure reproducible deployments and enable easier rollbacks.

**Current State:**
- `kasa-calcom` uses `ghcr.io/calcom/cal.com:latest`
- `kasa-paperless-ai` uses `clusterzx/paperless-ai:latest`
- `kasa-paperless-gpt` uses `icereed/paperless-gpt:latest`
- `kasa-azuracast` already uses `:stable` ✅

**Target State:**
All apps use specific version tags (e.g., `v4.0.8`, `1.2.3`, etc.)

## Acceptance Criteria

- [ ] Research latest stable versions for:
  - Cal.com: `ghcr.io/calcom/cal.com`
  - Paperless-AI: `clusterzx/paperless-ai`
  - Paperless-GPT: `icereed/paperless-gpt`
- [ ] Update `docker-compose.yml` for each app with pinned version
- [ ] Document version selection rationale in commit message
- [ ] Test each app starts successfully with pinned version
- [ ] Update `releaseNotes` in `umbrel-app.yml` for each app
- [ ] Run `./scripts/publish.sh` to sync to root
- [ ] Validation passes: `./scripts/validate.sh` exits with code 0

## Files to Modify

```
apps/kasa-calcom/docker-compose.yml (line ~10, server service image)
apps/kasa-paperless-ai/docker-compose.yml (line ~10, server service image)
apps/kasa-paperless-gpt/docker-compose.yml (line ~10, server service image)
apps/kasa-calcom/umbrel-app.yml (releaseNotes field)
apps/kasa-paperless-ai/umbrel-app.yml (releaseNotes field)
apps/kasa-paperless-gpt/umbrel-app.yml (releaseNotes field)
```

## AI Assistant Implementation Steps

### 1. Research Current Stable Versions

```bash
# Check Docker Hub / GitHub Container Registry for latest stable versions
# Example for Cal.com:
# Visit: https://github.com/calcom/cal.com/releases
# or: docker search ghcr.io/calcom/cal.com

# Document findings:
# - Cal.com: v4.x.x (specific version)
# - Paperless-AI: vX.X.X
# - Paperless-GPT: vX.X.X
```

### 2. Update docker-compose.yml Files

```bash
# Edit each app's docker-compose.yml in apps/ directory
# Example for Cal.com:

# Before:
#   image: ghcr.io/calcom/cal.com:latest

# After:
#   image: ghcr.io/calcom/cal.com:v4.0.8
```

### 3. Update umbrel-app.yml Release Notes

```yaml
# Add to releaseNotes field:
releaseNotes: >-
  Pinned Docker image to specific version for reproducible deployments.
  Using Cal.com v4.0.8 (or specific version you selected).
```

### 4. Publish and Validate

```bash
# Sync changes to root
./scripts/publish.sh

# Run validation
./scripts/validate.sh

# Exit code must be 0
echo $?  # Should output: 0
```

### 5. Commit and Push

```bash
# Stage changes
git add apps/kasa-calcom apps/kasa-paperless-ai apps/kasa-paperless-gpt

# Commit (git hook will help with message)
git commit -m "feat(apps): pin Docker image versions for stability

- kasa-calcom: ghcr.io/calcom/cal.com:v4.0.8
- kasa-paperless-ai: clusterzx/paperless-ai:v1.2.3
- kasa-paperless-gpt: icereed/paperless-gpt:v0.5.0

This change eliminates the reproducibility risk of :latest tags
and enables easier rollback if issues occur.

Closes #[ISSUE_NUMBER]"

# Push to feature branch
git push -u origin claude/optimization-pin-versions-[SESSION_ID]
```

### 6. Create Pull Request

```bash
gh pr create \
  --title "feat(apps): pin Docker image versions for stability" \
  --body "Pins Docker images to specific versions for Cal.com, Paperless-AI, and Paperless-GPT.

## Changes
- Cal.com: v4.0.8
- Paperless-AI: v1.2.3
- Paperless-GPT: v0.5.0

## Testing
- [x] Validation passes
- [x] Version research documented
- [x] Release notes updated

Closes #[ISSUE_NUMBER]"
```

## Related Issues

- Part of Phase 1: Critical Security & Stability
- See: `docs/OPTIMIZATION_PLAN.md`

## AI Assistant Notes

**Important:**
- Always work in `apps/<app-id>/` directory, NOT root app directories
- Research actual current stable versions (don't guess!)
- Test that versions exist before committing
- Document version selection rationale in commit message
- Use `./scripts/publish.sh` before validating

**Version Selection Priority:**
1. Latest stable release tag (preferred)
2. Latest release candidate (if no stable)
3. Specific commit SHA (last resort)

**Avoid:**
- Don't use `:latest` or rolling tags
- Don't use very old versions
- Don't use `:edge`, `:dev`, `:nightly` in production
