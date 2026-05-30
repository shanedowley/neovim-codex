# ARCHITECTURE.md

# Neovim-Codex RC1.0 — System Architecture

Neovim-Codex is an AI-Assisted Engineering System (AIES) for Neovim.

The system is designed around:

- correctness
- control
- traceability
- recoverability
- reproducibility

This document describes the operational architecture and core engineering model of the system.

---

# Design Philosophy

Neovim-Codex is intentionally designed to behave more like:

- an engineering system

than:

- a generic AI editor plugin

The project prioritizes:

- observable execution
- explicit operator control
- deterministic workflows
- operational safety
- recoverable failure modes

The architecture assumes:

- AI systems can fail
- environments can degrade
- generated code must be inspectable
- operators should remain in control

---

# Core Operational Pipeline

High-level execution flow:

```text
Operator Action
    ↓
Prompt Construction
    ↓
Runner Preflight
    ↓
Health Validation
    ↓
Codex CLI Execution
    ↓
Response Capture
    ↓
Diff Preview
    ↓
Validation
    ↓
Explicit Confirmation
    ↓
Apply
    ↓
Operational Logging
```

This flow is intentionally layered.

No silent apply path exists.

---

# System Layers

## 1. Operator Layer

The operator initiates workflows via:

- keybindings
- visual selections
- commands
- scratchpad prompts

Examples:

- `<leader>cE`
- `<leader>ce`
- `<leader>cR`
- `:CodexHealth`

---

## 2. Prompt Layer

Prompt construction normalizes:

- instructions
- filetype context
- embedded code
- fenced language blocks

Primary responsibilities:

- prompt shaping
- context preparation
- embedded execution formatting

Key modules:

- `codex_prompt.lua`
- `prompt_store.lua`
- `prompt_version.lua`

---

## 3. Runner Layer

The runner is the operational orchestration layer.

Primary responsibilities:

- preflight validation
- health gate enforcement
- Codex CLI execution
- response capture
- failure handling
- operational logging

Key module:

```text
lua/codex/runner.lua
```

The runner is intentionally:

- state-aware
- failure-aware
- operationally observable

---

# Runner Preflight Model

Before execution begins, the runner validates operational readiness.

Examples:

- health status
- environment correctness
- prompt integrity

Blocked execution paths:

- degraded health
- failed validation
- missing prompt state

Example:

```text
healthcheck_not_pass
```

This prevents AI execution in degraded environments.

---

# Health System

Primary module:

```text
lua/codex/health.lua
```

Responsibilities:

- dependency validation
- environment inspection
- operational readiness
- bootstrap integrity

Interfaces:

- `:CodexHealth`
- bootstrap validation
- runner preflight checks

---

# Codex CLI Integration

Neovim-Codex delegates model execution to Codex CLI.

Primary module:

```text
lua/codex/cli.lua
```

Responsibilities:

- argv construction
- model selection
- execution contract
- CLI process orchestration

Execution occurs through:

- Neovim jobs
- buffered stdout/stderr capture
- asynchronous scheduling

---

# Preview System

The preview system is intentionally central to the architecture.

Generated changes are previewed before apply.

Primary responsibilities:

- unified diff rendering
- operator inspection
- explicit confirmation workflow

Primary module:

```text
lua/codex/preview.lua
```

Key principle:

```text
preview first, apply second
```

No silent mutation path exists.

---

# Validation Layer

Generated changes should validate before apply.

Examples:

- clang syntax validation
- constrained rewrite guards
- Treesitter-scoped refactor constraints

Primary modules:

- `clang.lua`
- `treesitter.lua`

This layer exists to reduce:

- malformed edits
- invalid syntax
- unsafe broad rewrites

---

# Apply Layer

Apply operations occur only after:

- preview
- validation
- explicit operator confirmation

The system intentionally avoids:

- autonomous mutation
- hidden auto-apply behavior

---

# Logging & Telemetry

Operational logging is treated as a first-class system concern.

Primary module:

```text
lua/codex_log.lua
```

Examples of logged events:

- start
- response
- latency
- fail
- validation
- apply
- preflight block

Logs are intended to support:

- observability
- debugging
- replayability
- operational trust

Default log location:

```text
~/.local/state/nvim/codex.log
```

---

# Recovery System

Failures are treated as operational events.

Primary responsibilities:

- capture failure state
- preserve diagnostics
- support inspection/recovery

Primary module:

```text
lua/codex_recovery.lua
```

Examples:

- health gate blocks
- validation failures
- execution failures

---

# Runtime Separation Model

Neovim-Codex intentionally separates:

- configuration
- runtime state
- cache
- operational logs

Expected XDG layout:

```text
~/.config/nvim
~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim
```

The bootstrap system validates this separation.

Runtime artefacts inside:

```text
~/.config/nvim
```

are treated as operational hygiene violations.

---

# Bootstrap Architecture

Primary script:

```text
bootstrap-nvim-codex-rc1_0.sh
```

Responsibilities:

- dependency checks
- config validation
- runtime separation enforcement
- lazy.nvim bootstrap
- operational health validation
- health gate integrity testing

Supported modes:

- `--check`
- `--sync`
- `--test-health-gate`

---

# Safety Model

Neovim-Codex intentionally optimizes for:

- controlled execution
- observable workflows
- deterministic behavior

Safety mechanisms include:

- preview-before-apply
- validation-before-apply
- health gates
- constrained refactor scopes
- operational logging
- explicit confirmation

The architecture assumes:

- generated code can be incorrect
- AI systems require supervision
- operator control must remain primary

---

# State Model

Operational state transitions are explicit.

Examples:

Health states:

- unknown
- healthcheck running
- ready
- blocked

Operational states:

- running
- preview
- validating
- applied
- failed

This improves:

- observability
- UX clarity
- operational debugging

Primary module:

```text
lua/codex/state.lua
```

---

# Treesitter Integration

Treesitter is used for:

- scoped refactor extraction
- syntax-aware operations
- constrained transformation workflows

This reduces:

- broad unsafe rewrites
- accidental file-wide mutation

Primary module:

```text
lua/codex/treesitter.lua
```

---

# Current RC1.0 Scope

Primary focus:

- macOS
- C/C++
- safe AI-assisted refactoring workflows
- operational observability

Secondary support:

- JavaScript debugging
- general embedded prompt workflows

Linux support remains experimental.

Windows is currently unsupported.

---

# Repository Boundary

Neovim-Codex RC1.0 ships as a curated engineering environment.

The repository contains:

- the core Neovim-Codex AIES subsystem
- supporting Neovim IDE infrastructure
- operational tooling
- demo assets
- workflow documentation

The operational support boundary primarily applies to:

- Codex workflows
- validation systems
- observability systems
- recovery systems
- C/C++ engineering workflows

Supporting Neovim UX components may evolve independently from the core AIES subsystem.

--

# Architectural Non-Goals

Neovim-Codex is NOT attempting to become:

- autonomous coding agent
- background AI mutator
- invisible automation system
- zero-review apply workflow

The system intentionally preserves:

- operator review
- operational visibility
- explicit control

---

# Long-Term Direction

Future architectural areas include:

- multi-language support
- OpenRouter abstraction
- telemetry standardization
- advanced recovery tooling
- workflow state indicators
- session memory
- cloud-hosted orchestration
- prompt externalization
- platform abstraction layer

---

# Summary

Neovim-Codex RC1.0 is designed as:

```text
AI-Assisted Engineering System
```

The architecture prioritizes:

- correctness
- control
- traceability
- recoverability
- reproducibility

The system is intentionally engineered around:

- observable workflows
- explicit approval
- deterministic operational behavior
- safe AI-assisted engineering
