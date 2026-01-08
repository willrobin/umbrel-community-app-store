---
name: Apply Security Hardening
about: Apply security hardening (cap_drop, security_opt, user) to all apps
title: '[Security] Apply security hardening to non-hardened apps'
labels: 'priority: high, type: security, scope: all-apps, ai-ready'
assignees: ''
---

## Task Description

Apply security hardening patterns to all apps following the Paperless-AI model. This includes dropping all capabilities, adding no-new-privileges security option, and configuring non-root users where applicable.

**Current State:**
- ✅ `kasa-paperless-ai` has full security hardening (reference implementation)
- ⚠️ `kasa-azuracast` runs with default capabilities
- ⚠️ `kasa-calcom` runs with default capabilities
- ⚠️ `kasa-paperless-gpt` runs with default capabilities

**Target State:**
All application services run with minimal capabilities and security restrictions

## Security Hardening Pattern

Based on `apps/kasa-paperless-ai/docker-compose.yml`:

```yaml
  server:
    user: "1000:1000"                    # Non-root user
    cap_drop:
      - ALL                              # Drop all capabilities
    security_opt:
      - no-new-privileges:true           # Prevent privilege escalation
    # ... rest of configuration
```

## Acceptance Criteria

### General
- [ ] Review Paperless-AI implementation as reference
- [ ] Apply hardening to suitable services (application services, not databases)
- [ ] Test apps still function correctly after hardening
- [ ] Document security changes in each app's README
- [ ] Run `./scripts/publish.sh` and `./scripts/validate.sh`

### Per-App Checklist

#### kasa-azuracast
- [ ] Add `cap_drop: ALL` to `web` service
- [ ] Add `cap_drop: ALL` to `stations` service
- [ ] Add `security_opt: no-new-privileges:true` to both
- [ ] Evaluate if non-root user is feasible (may need research)
- [ ] Test streaming functionality still works
- [ ] Document in README

#### kasa-calcom
- [ ] Add `cap_drop: ALL` to `server` service
- [ ] Add `security_opt: no-new-privileges:true`
- [ ] Evaluate if `user: "1000:1000"` is compatible
- [ ] Test Cal.com functionality (auth, scheduling, etc.)
- [ ] Document in README

#### kasa-paperless-gpt
- [ ] Add `cap_drop: ALL` to `server` service
- [ ] Add `security_opt: no-new-privileges:true`
- [ ] Add `user: "1000:1000"` (similar to Paperless-AI)
- [ ] Test Paperless-ngx connectivity
- [ ] Test Ollama LLM integration
- [ ] Document in README

## Files to Modify

```
apps/kasa-azuracast/docker-compose.yml (web, stations services)
apps/kasa-azuracast/README.md (security notes)

apps/kasa-calcom/docker-compose.yml (server service)
apps/kasa-calcom/README.md (security notes)

apps/kasa-paperless-gpt/docker-compose.yml (server service)
apps/kasa-paperless-gpt/README.md (security notes)
```

## AI Assistant Implementation Steps

### 1. Read Reference Implementation

```bash
# Study the security pattern
cat apps/kasa-paperless-ai/docker-compose.yml

# Note the security configuration:
# - user: "1000:1000"
# - cap_drop: ALL
# - security_opt: no-new-privileges:true
```

### 2. Apply to Each App

#### For kasa-azuracast (web and stations services):

```yaml
  web:
    user: "1000:1000"           # ADD (test if compatible)
    cap_drop:                   # ADD
      - ALL
    security_opt:               # ADD
      - no-new-privileges:true
    init: true
    image: ghcr.io/azuracast/azuracast:stable
    # ... rest of config

  stations:
    user: "1000:1000"           # ADD (test if compatible)
    cap_drop:                   # ADD
      - ALL
    security_opt:               # ADD
      - no-new-privileges:true
    init: true
    image: ghcr.io/azuracast/azuracast:stable
    # ... rest of config
```

**Note:** AzuraCast may require specific capabilities for streaming. If it fails to start, you may need to add back specific caps:

```yaml
cap_drop:
  - ALL
cap_add:
  - NET_BIND_SERVICE  # If needed for port binding
```

#### For kasa-calcom (server service):

```yaml
  server:
    user: "1000:1000"           # ADD (test if compatible)
    cap_drop:                   # ADD
      - ALL
    security_opt:               # ADD
      - no-new-privileges:true
    init: true
    image: ghcr.io/calcom/cal.com:latest  # (or pinned version)
    # ... rest of config
```

#### For kasa-paperless-gpt (server service):

```yaml
  server:
    user: "1000:1000"           # ADD (same as Paperless-AI)
    cap_drop:                   # ADD
      - ALL
    security_opt:               # ADD
      - no-new-privileges:true
    init: true
    image: icereed/paperless-gpt:latest  # (or pinned version)
    # ... rest of config
```

### 3. Important: Database Services

**Do NOT apply cap_drop: ALL to database services (db, redis)**

Databases may need specific capabilities. Only harden application services.

### 4. Test Functionality

```bash
# Test each app starts successfully
docker compose -f apps/kasa-azuracast/docker-compose.yml up -d
docker compose -f apps/kasa-azuracast/docker-compose.yml logs web

# Check for permission errors
# If errors occur, may need to adjust user or add specific capabilities
```

### 5. Document Security Changes

Add to each app's README.md:

```markdown
## Security

This app follows security hardening best practices:

- **Capabilities**: Drops all unnecessary Linux capabilities (`cap_drop: ALL`)
- **Privilege Escalation**: Prevents privilege escalation (`no-new-privileges:true`)
- **User**: Runs as non-root user (UID/GID 1000)

These restrictions minimize the attack surface and improve container isolation.
```

### 6. Publish and Validate

```bash
./scripts/publish.sh
./scripts/validate.sh
```

### 7. Commit and Push

```bash
git add apps/kasa-azuracast apps/kasa-calcom apps/kasa-paperless-gpt

git commit -m "feat(apps): apply security hardening across all apps

- Added cap_drop: ALL to application services
- Added no-new-privileges security option
- Configured non-root users where applicable

Following Paperless-AI security best practices pattern.
Reduces attack surface and improves container isolation.

Closes #[ISSUE_NUMBER]"

git push -u origin claude/optimization-security-hardening-[SESSION_ID]
```

### 8. Create Pull Request

```bash
gh pr create \
  --title "feat(apps): apply security hardening across all apps" \
  --body "Applies security hardening to AzuraCast, Cal.com, and Paperless-GPT.

## Security Improvements
- Drop all capabilities (cap_drop: ALL)
- Prevent privilege escalation (no-new-privileges)
- Non-root user execution (UID/GID 1000)

## Apps Updated
- [x] kasa-azuracast (web, stations)
- [x] kasa-calcom (server)
- [x] kasa-paperless-gpt (server)

## Testing
- [x] Apps start successfully
- [x] Functionality verified
- [x] Documentation updated

Follows the security pattern from kasa-paperless-ai.

Closes #[ISSUE_NUMBER]"
```

## Related Issues

- Part of Phase 1: Critical Security & Stability
- See: `docs/OPTIMIZATION_PLAN.md`

## AI Assistant Notes

**Important Considerations:**

1. **Test thoroughly**: Some apps may not work with `user: "1000:1000"`
   - If errors occur, try without the user directive first
   - Then just apply `cap_drop` and `security_opt`

2. **Database services**: Do NOT apply hardening to `db` or `redis` services
   - They may need specific capabilities
   - Focus on application services only

3. **Capability exceptions**: If app fails to start:
   ```yaml
   cap_drop:
     - ALL
   cap_add:
     - NET_BIND_SERVICE  # Example: if app needs to bind to ports < 1024
     - CHOWN             # Example: if app needs to change file ownership
   ```

4. **File permissions**: Non-root user may need proper volume permissions
   - Umbrel handles this via APP_DATA_DIR
   - But watch logs for permission denied errors

**Debugging:**

If an app fails to start after hardening:
```bash
# Check logs
docker compose logs [service-name]

# Look for:
# - "permission denied"
# - "operation not permitted"
# - capability-related errors

# Try relaxing restrictions one at a time to identify the issue
```

**Fallback Strategy:**

If full hardening breaks an app:
1. Keep `cap_drop: ALL` and `security_opt` (high priority)
2. Remove `user: "1000:1000"` (lower priority)
3. Document why full hardening isn't possible
4. Create follow-up issue to investigate proper non-root configuration
