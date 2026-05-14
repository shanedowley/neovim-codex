# Neovim-Codex RC1.0 — Release Notes

## Overview

Neovim-Codex RC1.0 is an AI-Assisted Engineering System (AIES) for Neovim focused on:

- correctness
- control
- traceability
- recoverability
- reproducibility

This project is intentionally designed as a disciplined engineering workflow rather than a fully autonomous AI coding agent.

The system prioritises:

- preview-first workflows
- explicit operator approval
- validation before apply
- operational observability
- recoverable failure handling

RC1.0 represents the first release candidate focused on operational stability, reproducibility, and real-world engineering usability.

---

# Core Philosophy

Neovim-Codex intentionally favours:

- explicit workflows over hidden automation
- inspectable behaviour over opaque mutation
- engineering discipline over “AI magic”
- human-in-the-loop operation over autonomous rewrite systems

The operator always remains in control of generated changes.

No silent apply path exists.

---

# Key Features

## Safe AI-Assisted Refactoring

- preview-first rewrite workflows
- explicit apply confirmation
- unified diff previews
- controlled code mutation
- constrained rewrite scopes

---

## Validation & Safety

- clang syntax validation
- Treesitter-scoped operations
- health gate enforcement
- runtime/config separation checks
- defensive operational guards

---

## Operational Observability

- structured operational logging
- workflow state tracking
- latency telemetry
- recovery capture
- operational diagnostics

---

## Bootstrap & Reproducibility

- repo-local bootstrap workflow
- fresh clone validation
- reproducible setup process
- XDG-compliant runtime separation
- operational health validation

---

# Demo Workflows

## D1 — Safe Refactor Workflow

Demonstrates:

- preview-first rewrites
- explicit apply confirmation
- clang validation
- controlled code mutation

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

See:

- `docs/demos/D3_OPERATIONAL_DIAGNOSTICS.md`

---

## D4 — Legacy Code Explainability

Demonstrates safe AI-assisted reasoning about existing C systems without modifying source code.

See:

- `docs/demos/D4_LEGACY_EXPLAINABILITY.md`

---

## D5 — Human-in-the-Loop Engineering

Demonstrates iterative refinement where the engineer reviews, rejects, refines, and explicitly approves generated output.

See:

- `docs/demos/D5_HUMAN_LOOP.md`

---

# Current RC1.0 Scope

Primary focus:

- macOS
- Neovim
- C/C++ engineering workflows
- safe AI-assisted refactoring
- operational observability

Secondary support exists for broader workflows inside the surrounding Neovim environment.

Linux support remains experimental.

Windows is currently unsupported.

---

# What This Is Not

Neovim-Codex is intentionally not:

- an autonomous coding agent
- a silent background mutator
- a zero-review apply system
- an “AI does everything” workflow

The architecture intentionally preserves explicit operator control.

---

# Installation

See:

- `README.md`
- `INSTALL.md`

Bootstrap validation:

```bash
./scripts/bootstrap-nvim-codex-rc1_0.sh --check
```

Health gate validation:

```bash
./scripts/bootstrap-nvim-codex-rc1_0.sh --test-health-gate
```

---

# Repository Structure

Key areas:

```text
lua/codex/      → Core operational runtime
codex/prompts/  → Prompt system
docs/demos/     → Workflow demonstrations
scripts/        → Bootstrap + operational tooling
```

---

# Known RC1.0 Limitations

- Linux support is experimental
- Windows support is not yet implemented
- CI pipelines are not yet integrated
- Packaging and installer workflows remain manual
- Multi-language workflows are still evolving

---

# Future Direction

Planned future areas include:

- Linux hardening
- Windows / WSL support
- CI validation pipelines
- OpenRouter abstraction
- OpenCode integration exploration
- multi-language expansion
- telemetry standardisation
- advanced recovery tooling
- standalone plugin extraction

Future OpenCode integration work may explore:

- alternative orchestration backends
- interchangeable AI execution providers
- broader model interoperability
- resilient multi-provider workflows
- operational redundancy beyond a single AI vendor

The long-term direction is to preserve the same operational philosophy:

- observable workflows
- explicit operator control
- deterministic execution
- safe AI-assisted engineering

regardless of underlying model provider or orchestration backend.

---

# Closing Notes

Neovim-Codex RC1.0 represents a deliberate attempt to build an AI-assisted engineering workflow that remains:

- observable
- inspectable
- deterministic
- safe
- operator-controlled

The goal is not maximum automation.

The goal is trustworthy engineering assistance.

