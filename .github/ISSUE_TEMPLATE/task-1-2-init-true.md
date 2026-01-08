---
name: Add init true to Database Services
about: Add init:true to database and cache services for proper signal handling
title: '[Stability] Add init: true to database and cache services'
labels: 'priority: critical, type: config, app: kasa-azuracast, app: kasa-calcom, ai-ready'
assignees: ''
---

## Task Description

Add `init: true` to database (MariaDB, PostgreSQL) and cache (Redis) services to ensure proper PID 1 signal handling and graceful shutdowns.

**Current State:**
- AzuraCast: `db` (MariaDB) and `redis` services lack `init: true`
- Cal.com: `db` (PostgreSQL) and `redis` services lack `init: true`
- Main application services already have `init: true` ✅

**Target State:**
All services have `init: true` for proper signal handling

## Background

Docker's `init: true` ensures that:
1. Zombie processes are properly reaped
2. SIGTERM signals are correctly forwarded to the main process
3. Graceful shutdowns work as expected
4. Database integrity is maintained during container stops

## Acceptance Criteria

- [ ] Add `init: true` to AzuraCast `db` service (MariaDB)
- [ ] Add `init: true` to AzuraCast `redis` service
- [ ] Add `init: true` to Cal.com `db` service (PostgreSQL)
- [ ] Add `init: true` to Cal.com `redis` service
- [ ] Run `./scripts/publish.sh` to sync changes
- [ ] Validation passes: `./scripts/validate.sh` exits with code 0
- [ ] Test that apps start and stop gracefully

## Files to Modify

```
apps/kasa-azuracast/docker-compose.yml
  - db service (~line 50-60)
  - redis service (~line 70-80)

apps/kasa-calcom/docker-compose.yml
  - db service (~line 30-40)
  - redis service (~line 50-60)
```

## AI Assistant Implementation Steps

### 1. Read Current Configuration

```bash
# Read AzuraCast docker-compose.yml
cat apps/kasa-azuracast/docker-compose.yml

# Read Cal.com docker-compose.yml
cat apps/kasa-calcom/docker-compose.yml

# Locate db and redis services
```

### 2. Add init: true to Each Service

**Pattern to follow:**

```yaml
  db:
    init: true              # ADD THIS LINE
    image: mariadb:10.11
    restart: unless-stopped
    # ... rest of configuration
```

**Apply to:**
- AzuraCast: `db` service
- AzuraCast: `redis` service
- Cal.com: `db` service
- Cal.com: `redis` service

### 3. Verify Indentation

Ensure `init: true` is at same indentation level as `image:`, `restart:`, etc.

```yaml
# ✅ CORRECT
  db:
    init: true
    image: mariadb:10.11
    restart: unless-stopped

# ❌ WRONG (indentation)
  db:
      init: true
    image: mariadb:10.11
```

### 4. Publish and Validate

```bash
# Sync to root directories
./scripts/publish.sh

# Validate all configurations
./scripts/validate.sh

# Should exit with 0
```

### 5. Optional: Test Graceful Shutdown

```bash
# Start services
docker compose -f apps/kasa-azuracast/docker-compose.yml up -d

# Check that init process is PID 1
docker compose -f apps/kasa-azuracast/docker-compose.yml exec db ps aux

# Should show init or docker-init as PID 1

# Stop gracefully
docker compose -f apps/kasa-azuracast/docker-compose.yml down

# Check logs for graceful shutdown messages
```

### 6. Commit and Push

```bash
# Stage changes
git add apps/kasa-azuracast apps/kasa-calcom

# Commit
git commit -m "fix(apps): add init: true to database services for graceful shutdown

- kasa-azuracast: Added to db and redis services
- kasa-calcom: Added to db and redis services

This ensures proper PID 1 signal handling and graceful shutdowns,
reducing the risk of database corruption during container stops.

Closes #[ISSUE_NUMBER]"

# Push
git push -u origin claude/optimization-init-true-[SESSION_ID]
```

### 7. Create Pull Request

```bash
gh pr create \
  --title "fix(apps): add init: true to database services" \
  --body "Adds proper signal handling to database and cache services.

## Changes
- AzuraCast: Added init:true to db and redis
- Cal.com: Added init:true to db and redis

## Benefits
- Proper PID 1 signal handling
- Graceful shutdowns
- Reduced corruption risk

## Testing
- [x] Validation passes
- [x] Proper indentation verified

Closes #[ISSUE_NUMBER]"
```

## Related Issues

- Part of Phase 1: Critical Security & Stability
- See: `docs/OPTIMIZATION_PLAN.md`

## AI Assistant Notes

**Important:**
- `init: true` should be added to ALL services, not just main app services
- Database services benefit most from proper signal handling
- Indentation must match existing YAML structure
- This is a low-risk change (adds safety, doesn't change behavior)

**Verification:**
After applying changes, you can verify with:
```bash
grep -A 5 "db:" apps/kasa-azuracast/docker-compose.yml | grep "init: true"
grep -A 5 "redis:" apps/kasa-azuracast/docker-compose.yml | grep "init: true"
```

Should return matches showing `init: true` for both services.
