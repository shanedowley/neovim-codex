# Neovim-Codex Operations Guide

## Purpose

This document describes the operational behaviour of the Neovim-Codex AI-Assisted Engineering System (AIES).

Focus:

- reliability
- diagnostics
- validation
- observability
- recovery
- operational safety

---

# Core Operational Principles

1. Correctness over convenience
2. Explicit user control
3. Validation before apply
4. Observable workflows
5. Recoverable failures
6. No silent mutation
7. No hidden automation

---

# Operational Workflow

Standard workflow:

1. User invokes Codex operation
2. Prompt logged
3. Workflow state enters `running`
4. Codex executes
5. Validation executes
6. Preview/confirm flow executes (where applicable)
7. Apply/reject decision occurs
8. Workflow state updated
9. Latency and operational events logged

---

# Health System

## Full diagnostics

```vim
:CodexHealth
```
