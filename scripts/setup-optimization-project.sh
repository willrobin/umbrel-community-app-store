#!/bin/bash
# Setup Script for umbrelOS 1.5 Optimization Project
# Creates GitHub Project Board, Labels, and Issues

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "umbrelOS 1.5 Optimization Project Setup"
echo "=========================================="
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed"
    echo "Install: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is installed and authenticated"
echo ""

# ==========================================
# Step 1: Create Labels
# ==========================================

echo "📋 Creating labels..."

create_label() {
    local name="$1"
    local color="$2"
    local description="$3"

    if gh label list | grep -q "^${name}"; then
        echo "  ⏭️  Label already exists: ${name}"
    else
        gh label create "$name" --color "$color" --description "$description"
        echo "  ✅ Created label: ${name}"
    fi
}

# Priority labels
create_label "priority: critical" "d73a4a" "Critical security/stability issues"
create_label "priority: high" "ff6b6b" "Important improvements"
create_label "priority: medium" "fbca04" "Nice-to-have enhancements"
create_label "priority: low" "0e8a16" "Future improvements"

# Type labels
create_label "type: security" "b60205" "Security-related changes"
create_label "type: config" "1d76db" "Configuration improvements"
create_label "type: docs" "0075ca" "Documentation updates"
create_label "type: refactor" "5319e7" "Code refactoring"
create_label "type: enhancement" "a2eeef" "New features or enhancements"

# App-specific labels
create_label "app: kasa-azuracast" "e99695" "AzuraCast app"
create_label "app: kasa-calcom" "f9d0c4" "Cal.com app"
create_label "app: kasa-paperless-ai" "c2e0c6" "Paperless-AI app"
create_label "app: kasa-paperless-gpt" "bfdadc" "Paperless-GPT app"

# Scope labels
create_label "scope: all-apps" "fef2c0" "Affects all apps"

# Workflow labels
create_label "ai-ready" "7057ff" "Ready for AI assistant to implement"
create_label "blocked" "d93f0b" "Blocked by dependency or external factor"
create_label "needs-review" "fbca04" "Needs human review"

echo ""

# ==========================================
# Step 2: Create GitHub Project
# ==========================================

echo "📊 Creating GitHub Project..."

PROJECT_NAME="umbrelOS 1.5 Optimization"

# Check if project already exists
if gh project list | grep -q "$PROJECT_NAME"; then
    echo "  ⏭️  Project already exists: $PROJECT_NAME"
    echo "  ℹ️  Skipping project creation"
else
    gh project create \
        --title "$PROJECT_NAME" \
        --body "Systematic improvement of Kasa Community App Store apps for umbrelOS 1.5 compliance"
    echo "  ✅ Created project: $PROJECT_NAME"
fi

echo ""

# ==========================================
# Step 3: Create Issues from Templates
# ==========================================

echo "🎫 Creating issues from templates..."

TEMPLATE_DIR="${REPO_ROOT}/.github/ISSUE_TEMPLATE"

create_issue_from_template() {
    local template_file="$1"
    local issue_title="$2"
    local labels="$3"

    if [ ! -f "$template_file" ]; then
        echo "  ⚠️  Template not found: $template_file"
        return 1
    fi

    # Check if issue already exists
    if gh issue list --state all --search "$issue_title" | grep -q "$issue_title"; then
        echo "  ⏭️  Issue already exists: $issue_title"
        return 0
    fi

    # Create issue
    gh issue create \
        --title "$issue_title" \
        --label "$labels" \
        --body-file "$template_file"

    echo "  ✅ Created issue: $issue_title"
}

# Phase 1 Issues
echo ""
echo "Phase 1: Critical Security & Stability"
create_issue_from_template \
    "${TEMPLATE_DIR}/task-1-1-pin-versions.md" \
    "[Security] Pin Docker image versions for all apps" \
    "priority: critical,type: security,scope: all-apps,ai-ready"

create_issue_from_template \
    "${TEMPLATE_DIR}/task-1-2-init-true.md" \
    "[Stability] Add init: true to database and cache services" \
    "priority: critical,type: config,app: kasa-azuracast,app: kasa-calcom,ai-ready"

create_issue_from_template \
    "${TEMPLATE_DIR}/task-1-3-security-hardening.md" \
    "[Security] Apply security hardening to non-hardened apps" \
    "priority: high,type: security,scope: all-apps,ai-ready"

# Additional Phase 1 Issue (without template, inline)
if ! gh issue list --state all --search "[Config] Replace CHANGE_ME placeholder" | grep -q "CHANGE_ME"; then
    gh issue create \
        --title "[Config] Replace CHANGE_ME placeholder with APP_SEED in Paperless-GPT" \
        --label "priority: high,type: config,app: kasa-paperless-gpt,ai-ready" \
        --body "## Task Description

Replace hardcoded \`PAPERLESS_API_TOKEN: \"CHANGE_ME\"\` placeholder with either \${APP_SEED} or clear documentation.

## Acceptance Criteria
- [ ] Evaluate if Paperless-ngx API token can use APP_SEED
- [ ] If yes: Update docker-compose.yml to use \${APP_SEED}
- [ ] If no: Add clear setup instructions in README
- [ ] Document token generation process

## Files to Modify
\`\`\`
apps/kasa-paperless-gpt/docker-compose.yml
apps/kasa-paperless-gpt/README.md
\`\`\`

Part of Phase 1 - See docs/OPTIMIZATION_PLAN.md"
    echo "  ✅ Created issue: [Config] Replace CHANGE_ME placeholder"
fi

echo ""

# ==========================================
# Step 4: Summary
# ==========================================

echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Next Steps:"
echo ""
echo "1. View Project Board:"
echo "   gh project list"
echo ""
echo "2. View Created Issues:"
echo "   gh issue list --label 'ai-ready'"
echo ""
echo "3. Start Implementation:"
echo "   - Pick an issue with 'ai-ready' label"
echo "   - Create feature branch: claude/optimization-{issue-num}-{desc}-{session}"
echo "   - Follow CLAUDE.md guidelines"
echo "   - See docs/OPTIMIZATION_PLAN.md for details"
echo ""
echo "4. AI Assistant Quick Start:"
echo "   gh issue list --label 'ai-ready' --label 'priority: critical'"
echo ""
echo "=========================================="
echo ""
