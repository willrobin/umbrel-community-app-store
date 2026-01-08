# Documentation Directory

This directory contains comprehensive documentation for the Kasa Community App Store optimization and development.

## Available Documentation

### 📋 Planning & Strategy

- **[OPTIMIZATION_PLAN.md](OPTIMIZATION_PLAN.md)** - Complete optimization strategy for umbrelOS 1.5
  - Detailed task breakdown
  - Phase-based implementation approach
  - Success metrics and timelines
  - GitHub workflow integration

### 🤖 AI Assistant Guides

- **[AI_WORKFLOW_GUIDE.md](AI_WORKFLOW_GUIDE.md)** - Step-by-step guide for AI assistants
  - Complete workflow from task selection to PR creation
  - Troubleshooting common issues
  - Best practices and critical rules
  - Quick reference commands

- **[GIT_WORKFLOW_BEST_PRACTICES.md](GIT_WORKFLOW_BEST_PRACTICES.md)** - Git workflow strategy
  - One branch per task vs. long-lived feature branches
  - When to combine vs. split changes
  - Real-world examples and anti-patterns
  - Decision trees and checklists

### ✅ Checklists

- **[app-checklist.md](app-checklist.md)** - Pre-submission checklist for apps
  - Required files verification
  - Configuration validation
  - Documentation requirements

## Quick Start

### For AI Assistants (Claude Code, ChatGPT Codex)

1. **Read first:** [AI_WORKFLOW_GUIDE.md](AI_WORKFLOW_GUIDE.md)
2. **Understand context:** [OPTIMIZATION_PLAN.md](OPTIMIZATION_PLAN.md)
3. **Setup GitHub:** Run `./scripts/setup-optimization-project.sh`
4. **Pick a task:** `gh issue list --label "ai-ready"`
5. **Start working:** Follow workflow guide

### For Human Developers

1. **Read:** [../CLAUDE.md](../CLAUDE.md) - Main repository guide
2. **Review:** [OPTIMIZATION_PLAN.md](OPTIMIZATION_PLAN.md) - Understand strategy
3. **Setup:** Run `./scripts/setup-optimization-project.sh`
4. **Contribute:** See [../CONTRIBUTING.md](../CONTRIBUTING.md)

## Document Overview

| Document | Purpose | Audience | Status |
|----------|---------|----------|--------|
| OPTIMIZATION_PLAN.md | umbrelOS 1.5 optimization strategy | All | Active |
| AI_WORKFLOW_GUIDE.md | AI assistant step-by-step guide | AI Assistants | Active |
| app-checklist.md | Pre-submission verification | Developers | Active |

## Integration with Other Documentation

This directory works together with:

- **[../CLAUDE.md](../CLAUDE.md)** - Main AI assistant guide for the repository
- **[../DEVELOPMENT.md](../DEVELOPMENT.md)** - Development workflow and guidelines
- **[../CONTRIBUTING.md](../CONTRIBUTING.md)** - Contribution guidelines
- **[../AGENTS.md](../AGENTS.md)** - AI agent specific guidelines
- **[../.github/ISSUE_TEMPLATE/](../.github/ISSUE_TEMPLATE/)** - Issue templates for tasks

## Workflow Diagram

```
                    ┌─────────────────────────┐
                    │   OPTIMIZATION_PLAN.md  │
                    │   (Strategy & Phases)   │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   GitHub Project Setup  │
                    │   (Issues, Labels, etc) │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │  AI_WORKFLOW_GUIDE.md   │
                    │  (Step-by-step impl.)   │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Implementation        │
                    │   (AI or Human Dev)     │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Pull Request          │
                    │   (Review & Merge)      │
                    └─────────────────────────┘
```

## Contributing to Documentation

When updating documentation:

1. **Keep consistency** - Follow existing formatting and structure
2. **Update this README** - If adding new documents
3. **Cross-reference** - Link related documents
4. **Version control** - Update "Last Updated" dates
5. **Validate markdown** - Ensure proper rendering

## Support

For questions or issues:

- **General questions:** See [../CLAUDE.md](../CLAUDE.md)
- **Optimization questions:** See [OPTIMIZATION_PLAN.md](OPTIMIZATION_PLAN.md)
- **Workflow questions:** See [AI_WORKFLOW_GUIDE.md](AI_WORKFLOW_GUIDE.md)
- **GitHub Issues:** Open an issue in the repository

---

**Last Updated:** 2026-01-08
