# Neovim-Codex RC1.0

AI-Assisted Engineering System (AIES) for Neovim.

Neovim-Codex is designed for engineers who want AI-assisted workflows with:

- correctness
- control
- traceability
- recoverability
- reproducibility

This project emphasizes:
- observable execution
- explicit operator approval
- preview-before-apply workflows
- operational safety
- deterministic engineering behavior

Neovim-Codex is intentionally designed to behave more like:
- an engineering system

than:
- a generic AI editor plugin

---

# Core Principles

## Correctness

Generated changes should validate before apply.

Examples:
- clang / clang++ validation
- constrained refactor flows
- preflight health checks

---

## Control

The operator remains in control.

The system emphasizes:
- diff previews
- explicit confirmation
- no silent auto-apply

---

## Traceability

Operational events are logged.

Examples:
- prompt execution
- latency
- failures
- validation
- apply events

---

# Supported Platforms

| Platform | Status |
|---|---|
| macOS | Supported |
| Linux | Experimental |
| Windows | Unsupported |

RC1.0 is primarily developed and tested on macOS Apple Silicon.

---

# Requirements

## Required

- Neovim 0.10+
- git
- clang
- diff

## Optional

- Node.js
- npm
- Codex CLI

Without Codex CLI, AI-assisted workflows will be unavailable.

---

# Quick Start

## 1. Clone the repository

```bash
git clone <your-repo-url> ~/.config/nvim
```

---

## 2. Run bootstrap

Fast validation:

```bash
~/bin/bootstrap-nvim-codex-rc1_0.sh --check
```

Full sync:

```bash
~/bin/bootstrap-nvim-codex-rc1_0.sh --sync
```

Health gate integrity test:

```bash
~/bin/bootstrap-nvim-codex-rc1_0.sh --test-health-gate
```

---

## 3. Launch Neovim

```bash
nvim
```

---

# Demo Workflows

## D1 — Safe Refactor Workflow

Demonstrates:

- preview-first rewrites
- explicit apply confirmation
- clang validation
- controlled code mutation

<!-- EMBED: d1-safe-refactor.gif -->

See:

- `docs/demos/D1_SAFE_REFACTOR.md`

---

## D2 — Failure Recovery and Explainability

Demonstrates:

- validation rejection
- protected active buffers
- recovery capture
- failure explainability
- operational recovery workflows

<!-- EMBED: d2-failure-recovery.gif -->

See:

- `docs/demos/D2_FAILURE_RECOVERY.md`

---

## D3 — Operational Diagnostics

Demonstrates:

- operational health checks
- workflow state tracking
- latency telemetry
- structured logging
- operational observability

<!-- EMBED: d3-operational-diagnostics.gif -->

See:

- `docs/demos/D3_OPERATIONAL_DIAGNOSTICS.md`

---

## D4 — Legacy Code Explainability

Demonstrates safe AI-assisted reasoning about existing C systems without modifying source code.

<!-- EMBED: d4-legacy-explainability.gif -->

See:

- `docs/demos/D4_LEGACY_EXPLAINABILITY.md`

---

## D5 — Human-in-the-Loop Engineering

Demonstrates iterative refinement where the engineer reviews, rejects, refines, and explicitly approves generated output.

<!-- EMBED: d5-human-loop.gif -->

See:

- `docs/demos/D5_HUMAN_LOOP.md`

---

# Demo Workflows

## Explain Selected Code

Select code in visual mode:

```text
<leader>cE
```

---

## Rewrite Selected Code

Select code in visual mode:

```text
<leader>ce
```

---

## Refactor Current Function

Place cursor inside a function:

```text
<leader>cR
```

---

## Reopen Diff Preview

```text
<leader>cd
```

or:

```text
<leader>cD
```

---

## Open Scratchpad Prompt

```text
<leader>cs
```

---

# Keybindings

| Keybinding | Action |
|---|---|
| `<leader>cE` | Explain selected code |
| `<leader>ce` | Rewrite selected code |
| `<leader>cR` | Refactor current function |
| `<leader>cd` | Reopen diff preview |
| `<leader>cD` | Reopen diff preview |
| `<leader>cs` | Open scratchpad prompt |
| `:CodexHealth` | Run operational diagnostics |

---

# Bootstrap Modes

| Mode | Purpose |
|---|---|
| `--check` | Fast validation + healthcheck |
| `--sync` | Full plugin sync + validation |
| `--test-health-gate` | Validate preflight health blocking |

---

# Example Healthy Bootstrap Output

```text
✅ Config directory is clean
✅ lazy.nvim already present
✅ Health gate enforcement: PASS
```

---

# Documentation

| Document | Purpose |
|---|---|
| `ARCHITECTURE.md` | System architecture and operational model |
| `CONTRIBUTING.md` | Contribution guidelines |
| `LICENSE` | License information |

---

# Safety Model

Neovim-Codex intentionally emphasizes:
- preview-before-apply
- validation-before-apply
- explicit confirmation
- operational visibility

No silent auto-apply workflow exists.

---

# Troubleshooting

Run:

```vim
:CodexHealth
```

Inspect operational log:

```text
~/.local/state/nvim/codex.log
```

---

# Philosophy

Neovim-Codex is designed around:
- observable workflows
- deterministic execution
- explicit operator control
- safe AI-assisted engineering