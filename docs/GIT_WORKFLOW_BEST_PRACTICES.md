# Git Workflow Best Practices
# Für Kasa Community App Store Optimierung

> **Audience**: Developers & AI Assistants
> **Purpose**: Define optimal Git workflow for systematic app optimization
> **Version**: 1.0.0
> **Last Updated**: 2026-01-08

---

## 🎯 Recommended Workflow: One Branch Per Task

### Philosophy

**Small, focused branches** lead to:
- ✅ Easier code review
- ✅ Faster merge cycles
- ✅ Independent feature deployment
- ✅ Clearer git history
- ✅ Easier rollback if needed
- ✅ Parallel work by multiple contributors

---

## 📐 Branch Strategies Compared

### ❌ Anti-Pattern: Single Long-Lived Feature Branch

```
main
 └── claude/umbrelOS-app-optimization-JaPP1
      ├── commit 1: docs (2,800 lines)
      ├── commit 2: bug fixes (Cal.com, AzuraCast)
      ├── commit 3: pin versions (all apps)
      ├── commit 4: add init:true
      ├── commit 5: security hardening
      ├── commit 6: documentation
      └── commit 7: health checks

      Result: One massive PR with 50+ file changes
              → Hard to review
              → All-or-nothing merge
              → Mixed concerns
```

**Problems:**
- 🔴 Large PR = hard to review thoroughly
- 🔴 Mixed concerns (docs + features + fixes)
- 🔴 Cannot merge partial work
- 🔴 Blocks other contributors
- 🔴 Risk of merge conflicts if long-lived

---

### ✅ Best Practice: One Branch Per Task/Issue

```
main
 ├── claude/docs-optimization-plan-JaPP1         [PR #1] ✓ Merged
 ├── claude/fix-calcom-azuracast-JaPP1           [PR #2] ✓ Merged
 ├── claude/optimization-1-pin-versions-JaPP1    [PR #3] 🔄 Open
 ├── claude/optimization-2-init-true-JaPP1       [PR #4] ⏳ Ready
 └── claude/optimization-3-security-JaPP1        [PR #5] ⏳ Ready

Each PR: 5-15 files changed, single concern, clear scope
```

**Benefits:**
- ✅ Small PRs = quick review (< 30 min)
- ✅ Single concern = clear scope
- ✅ Independent merge timeline
- ✅ Parallel work possible
- ✅ Easy rollback if needed
- ✅ Clean git history

---

## 🔀 Detailed Workflow

### Step 1: Pick a Task from GitHub Issues

```bash
# View available tasks
gh issue list --label "ai-ready" --state open

# Pick one issue, e.g., Issue #5: "Pin Docker image versions"
gh issue view 5
```

**Rule:** One branch = One issue

---

### Step 2: Create Feature Branch from Latest main

```bash
# Always start from fresh main
git checkout main
git pull origin main

# Create task-specific branch
# Format: claude/{topic}-{issue-num}-{session-id}
git checkout -b claude/optimization-5-pin-versions-JaPP1
```

**Branch Naming Convention:**
```
claude/optimization-{issue-num}-{short-desc}-{session-id}

Examples:
  claude/optimization-1-pin-versions-JaPP1
  claude/optimization-2-init-true-JaPP1
  claude/fix-calcom-installation-JaPP1
  claude/docs-setup-guide-JaPP1
```

**Components:**
- `claude/` - Prefix (required for push permissions)
- `{topic}` - Category (optimization, fix, docs, feat)
- `{issue-num}` - GitHub issue number (optional but recommended)
- `{short-desc}` - Brief description (2-3 words, kebab-case)
- `{session-id}` - Session identifier (required, e.g., JaPP1)

---

### Step 3: Implement Changes

Follow acceptance criteria from GitHub issue.

**Best Practices:**
- Work in `apps/` directory only
- Make atomic commits (one logical change per commit)
- Test after each significant change

```bash
# Example: Pinning versions
# Edit files
nano apps/kasa-calcom/docker-compose.yml
nano apps/kasa-paperless-ai/docker-compose.yml

# Test
./scripts/publish.sh
./scripts/validate.sh
```

---

### Step 4: Commit Changes

**One commit per branch** is usually sufficient for small tasks.

```bash
git add apps/kasa-calcom apps/kasa-paperless-ai
git commit -m "feat(apps): pin Docker image versions for Cal.com and Paperless-AI

- kasa-calcom: ghcr.io/calcom/cal.com:v4.0.8
- kasa-paperless-ai: clusterzx/paperless-ai:v1.2.3

This eliminates reproducibility risk of :latest tags.

Closes #5"
```

**Commit Message Format:**
```
type(scope): subject

body (optional)

Closes #issue-number
```

---

### Step 5: Push to Remote

```bash
git push -u origin claude/optimization-5-pin-versions-JaPP1
```

**Important:** Session ID in branch name is required for push!

---

### Step 6: Create Pull Request

```bash
gh pr create \
  --title "feat(apps): pin Docker image versions" \
  --body "$(cat <<'EOF'
## Summary
Pins Docker images to specific versions for Cal.com and Paperless-AI.

## Changes
- Cal.com: v4.0.8
- Paperless-AI: v1.2.3

## Benefits
- Eliminates :latest tag reproducibility risk
- Enables easier rollback

## Testing
- [x] Validation passes
- [x] Apps start successfully

Closes #5
EOF
)"
```

**PR should:**
- Reference the issue (`Closes #5`)
- Be small enough to review in < 30 minutes
- Have clear testing checklist
- Include "why" not just "what"

---

### Step 7: Get Review & Merge

**After PR is created:**
1. Add label `needs-review` to issue
2. Wait for review/approval
3. Merge (preferably squash merge for clean history)
4. Delete branch after merge

**GitHub automatically:**
- Closes linked issue when PR merges
- Updates project board status

---

### Step 8: Start Next Task

```bash
# Pull merged changes
git checkout main
git pull origin main

# Start next task
git checkout -b claude/optimization-2-init-true-JaPP1
# ... repeat workflow ...
```

---

## 🧩 When to Combine vs. Split

### Combine in One Branch When:

✅ Changes are **tightly coupled**
- Cal.com installation fix + missing volumes (same root cause)
- Icon URL fix + publish.sh update (dependent changes)

✅ Changes form a **logical unit**
- Documentation: Optimization Plan + Workflow Guide + Issue Templates
- Security hardening: Apply same pattern to all 3 apps

✅ **Testing requires both** changes
- Database schema change + migration script
- Config change + corresponding documentation

**Example:**
```bash
# GOOD: Tightly coupled bug fixes
git checkout -b claude/fix-installation-issues-JaPP1
# Fix Cal.com installation
# Fix AzuraCast startup
# Both are "installation failures" - same category
git commit -m "fix(apps): resolve Cal.com and AzuraCast installation failures"
```

---

### Split into Separate Branches When:

🔀 Changes are **independent**
- Pin versions (Task 1) vs. Add init:true (Task 2)
- Documentation updates vs. code changes

🔀 Different **review expertise** needed
- Infrastructure changes (DevOps review)
- Documentation (Technical Writer review)
- Security hardening (Security review)

🔀 Different **merge priority**
- Critical bug fix (urgent) vs. Nice-to-have feature (can wait)

🔀 Changes affect **different apps**
- Exception: If applying same pattern to all apps (e.g., security hardening)

**Example:**
```bash
# GOOD: Independent changes
git checkout -b claude/docs-optimization-plan-JaPP1
# Add documentation only
git commit -m "docs: add optimization plan"
gh pr create --title "docs: Add optimization plan"

# Then separately:
git checkout main
git checkout -b claude/fix-calcom-JaPP1
# Fix Cal.com
git commit -m "fix(apps): fix Cal.com installation"
gh pr create --title "fix: Fix Cal.com installation"
```

---

## 🎨 Real-World Examples

### Example 1: Current State (Mixed Concerns)

**What we have now:**
```
Branch: claude/umbrelOS-app-optimization-JaPP1
Commits:
  1. docs: add optimization plan (2,800 lines docs)
  2. fix: Cal.com & AzuraCast issues (13 files changed)

Result: One PR with mixed concerns
```

**How to split it (if we were starting over):**
```
PR #1: claude/docs-optimization-plan-JaPP1
  - Only documentation files
  - Easy review for PM/Tech Lead
  - Can merge independently

PR #2: claude/fix-installation-issues-JaPP1
  - Only code fixes
  - Needs testing/QA review
  - Can merge after testing
```

**Decision for now:** Keep current branch as "Setup + Critical Fixes" since:
- Both are foundational (plan + fixes)
- Fixes are urgent
- Better to move forward than refactor history

---

### Example 2: Phase 1 Task Breakdown (Correct)

**Phase 1 has 4 tasks:**
1. Pin Docker versions
2. Add init:true to databases
3. Apply security hardening
4. Fix CHANGE_ME credentials

**Correct approach: 4 separate branches**

```bash
# Task 1: Pin versions
git checkout -b claude/optimization-1-pin-versions-JaPP1
# Changes: 3 docker-compose.yml files
# Scope: Version pinning only
# PR: ~10 lines changed
git commit -m "feat(apps): pin Docker image versions"

# Task 2: Add init:true (after Task 1 merged)
git checkout main && git pull
git checkout -b claude/optimization-2-init-true-JaPP1
# Changes: 2 docker-compose.yml files (azuracast, calcom)
# Scope: Init configuration only
# PR: ~4 lines changed
git commit -m "fix(apps): add init:true to database services"

# Task 3: Security hardening (after Task 2 merged)
git checkout main && git pull
git checkout -b claude/optimization-3-security-JaPP1
# Changes: 3 docker-compose.yml files + READMEs
# Scope: Security configuration only
# PR: ~30 lines changed
git commit -m "feat(apps): apply security hardening"

# Task 4: Fix CHANGE_ME (after Task 3 merged)
git checkout main && git pull
git checkout -b claude/optimization-4-fix-credentials-JaPP1
# Changes: 1 docker-compose.yml + 1 README
# Scope: Paperless-GPT credentials only
# PR: ~5 lines changed
git commit -m "fix(apps): replace hardcoded CHANGE_ME token"
```

**Result:**
- 4 small PRs (easy to review)
- Each mergeable independently
- Clear progression
- Rollback is granular

---

### Example 3: When to Combine (Security Hardening)

**Scenario:** Apply same security pattern to 3 apps

**Option A: Three separate PRs (❌ Not ideal)**
```
PR #1: Security hardening for Cal.com
PR #2: Security hardening for AzuraCast
PR #3: Security hardening for Paperless-GPT

Problem: Repetitive review, same pattern 3 times
```

**Option B: One combined PR (✅ Better)**
```
PR #1: Apply security hardening to all apps
  - Cal.com: Add cap_drop, security_opt, user
  - AzuraCast: Add cap_drop, security_opt, user
  - Paperless-GPT: Add cap_drop, security_opt, user

Benefit: Review pattern once, apply to all
```

**Decision criteria:**
- ✅ Same change pattern
- ✅ Same acceptance criteria
- ✅ Related testing (security audit)
- ✅ Logical grouping

---

## 🚫 Common Pitfalls to Avoid

### ❌ Pitfall 1: Kitchen Sink Branch

```bash
# BAD: Everything in one branch
git checkout -b claude/all-optimizations-JaPP1
# ... 2 weeks of work ...
# ... 150 files changed ...
gh pr create  # ← Reviewer sees 2,000 line PR and gives up
```

**Solution:** Break into tasks upfront

---

### ❌ Pitfall 2: Branch Hopping

```bash
# BAD: Start multiple branches without finishing
git checkout -b claude/task-1-JaPP1
# ... work 50% done ...
git checkout -b claude/task-2-JaPP1  # ← Started before finishing task 1
# ... work 30% done ...
git checkout -b claude/task-3-JaPP1  # ← Now have 3 incomplete branches
```

**Solution:** Finish one branch before starting next

---

### ❌ Pitfall 3: Forgetting to Rebase/Pull

```bash
# BAD: Branch diverges from main
git checkout -b claude/task-5-JaPP1  # ← Created 2 weeks ago
# ... meanwhile, tasks 1-4 merged to main ...
git push  # ← Now have merge conflicts
```

**Solution:** Always start from fresh main
```bash
git checkout main
git pull origin main  # ← Get latest
git checkout -b claude/task-5-JaPP1
```

---

### ❌ Pitfall 4: Mixing Bug Fixes with Features

```bash
# BAD: Mixing concerns
git checkout -b claude/pin-versions-JaPP1
# ... pin versions ...
# ... also fix unrelated Cal.com bug ...
# ... also update documentation ...
git commit -m "Various improvements"  # ← Unclear scope
```

**Solution:** Separate branches for bugs vs. features
```bash
# Fix bug immediately on separate branch
git checkout -b claude/fix-calcom-urgent-JaPP1
git commit -m "fix: resolve Cal.com startup failure"
gh pr create --label "priority: critical"

# Then continue with feature
git checkout main
git checkout -b claude/pin-versions-JaPP1
```

---

## 📊 Workflow Decision Tree

```
New task identified
     │
     ├─→ Is it a bug fix?
     │   └─→ YES → Create branch: claude/fix-{desc}-{session}
     │              Priority: Urgent
     │              Merge ASAP
     │
     ├─→ Is it documentation only?
     │   └─→ YES → Create branch: claude/docs-{desc}-{session}
     │              Review: Technical writer
     │              Can merge independently
     │
     ├─→ Is it part of optimization plan?
     │   └─→ YES → Create branch: claude/optimization-{num}-{desc}-{session}
     │              Follow issue template
     │              Sequential with other optimizations
     │
     └─→ Is it a new feature?
         └─→ YES → Create branch: claude/feat-{desc}-{session}
                   Discuss scope first
                   May need design review
```

---

## 📝 Template: PR Description

Use this template for all PRs:

```markdown
## Summary
[1-2 sentence summary of what changed]

## Changes
- [Bullet list of specific changes]
- [Be concrete: "Added X to Y", not "Improved things"]

## Why
[Why was this change needed? What problem does it solve?]

## Testing
- [ ] Validation passes: ./scripts/validate.sh
- [ ] Manual testing performed
- [ ] Documentation updated

## Related
Closes #{issue-number}
Part of [Phase X] optimization

## Screenshots (if applicable)
[Before/After screenshots for UI changes]
```

---

## ✅ Checklist: Before Creating PR

- [ ] Branch name follows convention: `claude/{topic}-{desc}-{session}`
- [ ] Branch starts from latest `main`
- [ ] Only one logical change per branch
- [ ] All files in `apps/` directory (not root)
- [ ] Ran `./scripts/publish.sh`
- [ ] Ran `./scripts/validate.sh` (exit code 0)
- [ ] Commit message follows conventional commits
- [ ] Commit message includes `Closes #{issue}`
- [ ] PR description includes testing checklist
- [ ] No secrets committed (`git diff` checked)

---

## 🎓 Summary: Golden Rules

1. **One branch = One issue** (or one tightly-coupled set of changes)
2. **Start from fresh main** every time
3. **Small PRs** (< 20 files changed, < 300 lines)
4. **Clear naming** (claude/{topic}-{desc}-{session})
5. **Atomic commits** (one logical change per commit)
6. **Link issues** (Closes #X in commit message)
7. **Test before push** (publish.sh && validate.sh)
8. **Review checklist** (always include testing steps)

---

## 🚀 Next Steps for This Project

### Immediate Action (Current Branch)

Since we already have work on `claude/umbrelOS-app-optimization-JaPP1`:

```bash
# Create PR for current state
gh pr create \
  --title "feat: Add optimization plan and fix critical app issues" \
  --body "See commit messages for details. Closes no issue (foundational work)."

# After merge, follow new workflow
```

### Future Work (New Workflow)

```bash
# Run setup script
./scripts/setup-optimization-project.sh

# Pick task from GitHub Issues
gh issue list --label "ai-ready"

# Create focused branch
git checkout -b claude/optimization-1-pin-versions-JaPP1

# Follow workflow above...
```

---

## 📚 Additional Resources

- **Main Guide**: [CLAUDE.md](../CLAUDE.md) - Repository guidelines
- **Workflow**: [AI_WORKFLOW_GUIDE.md](AI_WORKFLOW_GUIDE.md) - Step-by-step
- **Plan**: [OPTIMIZATION_PLAN.md](OPTIMIZATION_PLAN.md) - Strategy
- **GitHub Flow**: https://docs.github.com/en/get-started/quickstart/github-flow

---

**Version**: 1.0.0
**Created**: 2026-01-08
**Maintained by**: Kasa Community
**Feedback**: Open GitHub issue or discussion
