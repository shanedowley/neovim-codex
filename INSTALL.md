# INSTALL.md

# Neovim-Codex Release 1.1 — Installation & Operations Guide

This document describes:

- installation
- bootstrap
- upgrade workflows
- runtime layout
- operational expectations

Neovim-Codex is designed as an AI-Assisted Engineering System (AIES) for Neovim.

The installation model prioritizes:

- reproducibility
- operational clarity
- deterministic setup
- runtime hygiene

---

# Supported Platforms

| Platform | Status |
| -------- | ------ |
| macOS | Supported |
| Linux | Experimental |
| Windows | Unsupported |

Release 1.1 is primarily developed and tested on:

- macOS
- Apple Silicon
- XDG-style Neovim layout

Linux support is currently experimental.

---

# Requirements

## Required Dependencies

| Dependency | Purpose |
| ---------- | ------- |
| Neovim 0.11+ | Editor runtime |
| git | Plugin and repository management |
| clang | Validation pipeline |
| diff | Diff generation and preview |

---

## AI Workflow Dependency

| Dependency | Purpose |
| ---------- | ------- |
| Codex CLI | AI-assisted workflows |

Without Codex CLI:

- Neovim remains operational
- AI-assisted workflows will be unavailable

---

## Optional Dependencies

| Dependency | Purpose |
| ---------- | ------- |
| Node.js | JavaScript tooling |
| npm | JS debug adapter ecosystem |

---

# Recommended Installation Layout

Neovim-Codex expects an XDG-style Neovim structure.

Expected directories:

```text
~/.config/nvim
~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim
```

Configuration should live in:

```text
~/.config/nvim
```

Runtime state should NOT appear inside:

```text
~/.config/nvim
```

The bootstrap system validates this contract.

---

# Installation

## 1. Clone the Repository

Recommended installation location:

```bash
git clone https://github.com/shanedowley/neovim-codex.git ~/.config/nvim
```

---

## 2. Ensure Bootstrap Script Exists

Example location:

```text
./scripts/bootstrap-nvim-codex-r1_1.sh
```

Ensure executable permissions:

```bash
chmod +x ./scripts/bootstrap-nvim-codex-r1_1.sh
```

---

# Bootstrap Modes

The bootstrap system validates:

- platform support
- dependencies
- Neovim config presence
- runtime/config separation
- lazy.nvim installation
- operational health

---

## `--check`

Fast validation mode.

Runs:

- dependency checks
- config validation
- runtime hygiene checks
- healthcheck reporting

Example:

```bash
./scripts/bootstrap-nvim-codex-r1_1.sh --check
```

Expected healthy output:

```text
✅ Config directory is clean
✅ lazy.nvim already present
```

This mode:

- does NOT overwrite configuration
- does NOT modify Lua config files

May:

- bootstrap `lazy.nvim` if missing

---

## `--sync`

Full environment reconciliation.

Runs:

- everything in `--check`
- `Lazy! sync`

Example:

```bash
./scripts/bootstrap-nvim-codex-r1_1.sh --sync
```

This mode may:

- install plugins
- update plugins
- clean removed plugins
- rebuild plugin state

---

## Is `--sync` Safe?

Yes — assuming your setup is healthy and version-controlled.

`--sync`:

- does NOT overwrite Neovim configuration
- does NOT reset your Lua files
- does NOT wipe runtime state

It reconciles installed plugins against the current Lazy.nvim configuration.

Plugin updates may occur unless versions are pinned via:

```text
lazy-lock.json
```

---

## `--test-health-gate`

Operational integrity validation.

Tests:

- runner preflight blocking
- health gate enforcement
- operational logging integrity

Example:

```bash
./scripts/bootstrap-nvim-codex-r1_1.sh --test-health-gate
```

Expected healthy output:

```text
✅ Health gate enforcement: PASS
```

This test intentionally validates:

- blocked execution
- preflight failure handling
- logging behaviour

No Codex execution should occur during this test.

---

# First Startup

Launch Neovim:

```bash
nvim
```

Expected initial status:

```text
? Codex Unknown
```

This is normal.

Release 1.1 uses a Stale-While-Revalidate health model and does not perform a startup healthcheck.

Recommended first command:

```vim
:CodexHealth
```

This validates:

- Codex CLI availability
- runtime integrity
- dependency health
- operational readiness

---

# First Demo Workflow

Open a C or C++ source file.

Example:

```bash
nvim hello.c
```

Select code in visual mode.

Run:

```text
<leader>cE
```

This demonstrates:

- Codex execution
- output handling
- operational workflow
- observable execution

---

# Safe Upgrade Workflow

Recommended upgrade flow:

## 1. Ensure Clean Repository State

Example:

```bash
git status
```

or for bare dotfile repositories:

```bash
dotgit status
```

---

## 2. Backup Lockfile (Optional but Recommended)

```bash
cp lazy-lock.json lazy-lock.json.backup
```

---

## 3. Pull Latest Changes

```bash
git pull
```

---

## 4. Run Bootstrap Sync

```bash
./scripts/bootstrap-nvim-codex-r1_1.sh --sync
```

---

## 5. Validate Operational Health

Inside Neovim:

```vim
:CodexHealth
```

---

# Rollback Strategy

If a plugin or runtime regression occurs:

## Restore Lockfile

```bash
cp lazy-lock.json.backup lazy-lock.json
```

---

## Re-run Sync

```bash
./scripts/bootstrap-nvim-codex-r1_1.sh --sync
```

---

## Restore Previous Git Revision

Example:

```bash
git checkout <commit>
```

---

# Runtime Hygiene

Neovim-Codex intentionally separates:

- configuration
- runtime state
- cache
- operational logs

Runtime artefacts inside:

```text
~/.config/nvim
```

are treated as operational hygiene violations.

Examples of invalid runtime pollution:

```text
~/.config/nvim/lazy
~/.config/nvim/tmp
~/.config/nvim/nvim
```

The bootstrap system validates this automatically.

---

# Operational Logging

Default log location:

```text
~/.local/state/nvim/codex.log
```

Logs may include:

- execution events
- latency
- failures
- validation
- preflight blocks

Operational logging is intentionally treated as a first-class system concern.

---

# Common Installation Problems

## Codex CLI Missing

Expected warning:

```text
⚠️ codex CLI not found
```

Install Codex CLI and rerun bootstrap.

---

## macOS Gatekeeper Warnings

Some npm-installed Codex CLI shims may trigger unsigned executable warnings.

This does not necessarily indicate runtime failure.

Validate actual operational state using:

```vim
:CodexHealth
```

---

## Runtime Pollution Detected

Expected failure:

```text
❌ Runtime artefact found in config directory
```

Remove runtime state from:

```text
~/.config/nvim
```

Runtime state belongs in XDG runtime directories.

---

## lazy.nvim Missing

Bootstrap should automatically install:

```text
~/.local/share/nvim/lazy/lazy.nvim
```

---

## Health Gate Failure

Run:

```vim
:CodexHealth
```

Then inspect:

```text
~/.local/state/nvim/codex.log
```

---

# Operational Philosophy

Neovim-Codex intentionally emphasizes:

- preview-before-apply
- validation-before-apply
- explicit operator approval
- observable execution
- deterministic workflows

The system is intentionally designed around:

- operational transparency
- controlled mutation
- safe AI-assisted engineering

No silent auto-apply workflow exists.

---

# Related Documentation

| Document | Purpose |
| -------- | ------- |
| `README.md` | Project overview and quick start |
| `ARCHITECTURE.md` | System architecture and operational model |
| `CONTRIBUTING.md` | Contribution guidelines |
| `RELEASE_NOTES_R1_1.md` | Release 1.1 changes and upgrade information |
| `LICENSE` | License information |