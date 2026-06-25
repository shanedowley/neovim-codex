# Neovim-Codex

> Engineering first. AI second.

## Introduction

A Software Engineering Environment for Neovim built around validation, observability, explicit user control and operational safeguards.
Human-controlled. AI-assisted.

Current Release: R1.2

Neovim-Codex is designed for people who want AI-assisted workflows that remain:

- correct
- controllable
- traceable
- recoverable
- reproducible

Many AI coding tools optimise for speed and automation.

Neovim-Codex optimises for:

- engineering confidence
- operational safety
- explicit human review
- deterministic workflows
- inspectable behaviour

The goal is not autonomous coding.

The goal is trustworthy AI-assisted engineering.

## Quick Start

Clone the repository into your Neovim configuration directory:

```bash
git clone https://github.com/shanedowley/neovim-codex.git ~/.config/nvim
cd ~/.config/nvim
```

Run the bootstrap validation:

```bash
./scripts/bootstrap.sh --check
```

Launch Neovim and verify the installation:

```vim
:CodexHealth
```

Open any C or C++ source file, visually select some code, then press:

```text
<leader>cE
```

For complete installation and upgrade instructions, see `INSTALL.md`.

This project is architected as an AI-integrated engineering system rather than a generic AI editor plugin.

---

# Requirements

## Required

- Neovim 0.11+
- git
- clang
- diff
- Codex CLI
- authenticated OpenAI account

## Recommended

- Neovim 0.12.x
- macOS Apple Silicon

## Optional

- Node.js
- npm

Node.js and npm are only required for JavaScript-related debugging, testing, and development workflows.

### Notes

- Codex CLI must already be authenticated.
- Node.js is only required for JavaScript workflows.

---

## What is an AI-Assisted Engineering System?

Neovim-Codex treats AI as one component within a larger engineering workflow.

The system combines:

- AI-assisted reasoning
- validation gates
- operational diagnostics
- workflow state visibility
- failure recovery
- explicit human approval

The result is an engineering system that uses AI while preserving Correctness, Control, and Traceability.

AI is not the workflow.

AI is one component within the workflow.

Human judgement remains the final authority.

---

## Typical Engineering Workflow

Neovim-Codex treats AI as one stage within a controlled engineering workflow rather than the workflow itself.

```text
          Source Code
               │
               ▼
        Select Code
               │
               ▼
       Invoke Codex Workflow
               │
               ▼
      Preview Proposed Changes
               │
               ▼
      Validate Generated Output
               │
               ▼
     Explicit Human Approval
               │
               ▼
          Apply Changes
```

Every workflow is designed to preserve the three core engineering principles of the system:

- **Correctness** — generated changes are validated before application.
- **Control** — no source code is modified without explicit user approval.
- **Traceability** — operational behaviour is observable, logged, and reviewable.

AI contributes to the workflow, but it never replaces engineering judgement.

---

## Who This Is For

Neovim-Codex is designed for people who value:

- explicit control over AI-generated changes
- reviewable mutation workflows
- operational observability
- deterministic systems
- human-in-the-loop workflows
- safety over blind automation

---

## Release Highlights

This release includes:

- startup without blocking healthchecks
- Stale-While-Revalidate health validation
- runtime workflow visibility
- structured latency instrumentation
- streaming Codex output
- improved diagnostics and recovery workflows
- expanded documentation and operational guidance

---

# Key Features

## Safe Engineering

- Preview before apply
- Validation gates
- Explicit approval

## Observability

- Telemetry
- Workflow state
- Health model

## Recovery

- Failure capture
- Recovery reports

## Developer Experience

- Streaming AI output
- Legacy code explainability
- Interactive engineering workflows

---

# Why Neovim-Codex Exists

Neovim-Codex was built around a simple premise:

AI-assisted engineering systems should increase confidence, not reduce it.

AI should assist engineering workflows — not bypass them.

The system is intentionally designed to favour:

- preview-before-apply workflows
- explicit user approval
- operational observability
- deterministic execution
- recoverable failure handling
- validation before mutation

The user always remains in control.

No silent apply path exists.

To support this, Neovim-Codex makes workflow state, health state, and operational behaviour visible to the user.

---

# Workflow State Model

Operational state transitions are explicit and visible.

## Health States

- ? Unknown
- 🩺 Healthcheck Running
- ✓ Ready
- ✖ Blocked

## Operational States

- ⚙ Running
- 👁 Preview
- 🧪 Validating
- ✅ Applied
- ✖ Failed

Operational states always take precedence over health states.

---

# Startup Behaviour

Neovim-Codex never performs a blocking healthcheck during startup.

Startup remains immediately usable.

Health validation occurs only at point-of-use when a Codex workflow is executed.

---

# Runtime Health Model

Neovim-Codex uses a Stale-While-Revalidate health model.

What this means:

- startup uses the most recently known health state
- startup never performs a blocking healthcheck
- Neovim remains immediately usable
- a real healthcheck runs only when a Codex workflow is invoked

For example:

1. Yesterday, Codex was known to be healthy.
2. Neovim starts today.
3. The last known state is displayed immediately.
4. No startup delay occurs.
5. When the user runs a Codex workflow, the system performs a real healthcheck before execution.

This approach preserves responsiveness without sacrificing safety.

The user never waits for a healthcheck during startup, but Codex still refuses execution if runtime validation fails.

This is the rationale behind the term:

```text
Stale
=
Last known health state

While

Revalidate
=
Perform a real healthcheck only at point-of-use
```

This design eliminates startup delays while preserving the correctness guarantees of the execution gate.

---

# Runtime Status

Neovim-Codex exposes both health state and workflow state to the user.

Examples:

```text
? Codex Unknown
🩺 Codex Healthcheck Running
⚙ Codex Running
✓ Codex Ready
✖ Codex Blocked
```

Operational states automatically take precedence over health states.

This visibility is intentional and forms part of the system's observability model.

---

# Core Principles

## Correctness

Generated changes should validate before apply.

## Control

The user remains in control of all mutation.

## Traceability

Operational events are logged and inspectable.

## Recoverability

Failures are treated as operational events rather than hidden behaviour.

---

# Supported Platforms

| Platform | Status       |
| -------- | ------------ |
| macOS    | Supported    |
| Linux    | Experimental |
| Windows  | Unsupported  |

Neovim-Codex is currently developed and tested primarily on macOS Apple Silicon.

Linux support is an active future direction.

Windows support is planned as part of a future cross-platform strategy.

---

# First Run Walkthrough

## 1. Clone the Repository

```bash
git clone https://github.com/shanedowley/neovim-codex.git ~/.config/nvim
cd ~/.config/nvim
```

## 2. Run Bootstrap Validation

Fast validation:

```bash
./scripts/bootstrap.sh --check
```

Full sync:

```bash
./scripts/bootstrap.sh --sync
```

Health gate integrity test:

```bash
./scripts/bootstrap.sh --test-health-gate
```

## 3. Launch Neovim

```bash
nvim
```

## 4. Observe Startup Behaviour

Immediately after launch, the statusline will display:

```text
? Codex Unknown
```

This is expected.

Neovim-Codex uses a Stale-While-Revalidate health model.

No real healthcheck is performed during startup.

## 5. Verify Runtime Health

Inside Neovim:

```text
:CodexHealth
```

Review the diagnostic report and confirm all required checks pass.

## 6. Execute Your First Workflow

Open a C or C++ source file.

Visually select a block of code.

Run:

```text
<leader>cE
```

Neovim-Codex will:

1. validate runtime health
2. transition through workflow states
3. execute the explainability workflow
4. stream output into a scratch buffer

Expected state progression:

```text
🩺 Codex Healthcheck Running
⚙ Codex Running
✓ Codex Ready
```

You have now successfully executed your first Neovim-Codex workflow.

---

# Documentation

## Getting Started

- `INSTALL.md` — installation, bootstrap, and first-run setup

## Architecture

- `ARCHITECTURE.md` — architectural principles, workflow model, health model, state model, and operational design

## Operations

- `codex/docs/OPERATIONS.md` — operational procedures, diagnostics, recovery, and maintenance

## Release Documentation

- `RELEASE_NOTES_RC1_0.md` — historical Release Candidate 1.0 notes
- `codex/docs/RELEASE_SCOPE.md` — release scope and backlog tracking

## Repository Documentation

- `codex/docs/REPO_AUDIT.md` — repository structure, audit findings, and engineering review notes

## In-Editor Help

- `:CodexCommands`
- `:CodexHealth`
- `:CodexState`

---

# Engineering Workflows

Neovim-Codex is organised around engineering workflows rather than isolated commands.

Each workflow is designed to support Correctness, Control, and Traceability throughout the software development lifecycle.

## D1 — Safe Refactor Workflow

Demonstrates:

- AI-assisted code modification
- preview-before-apply review
- explicit user approval
- validation before mutation
- controlled source-code changes

This workflow demonstrates the core AIES principle that generated changes should be reviewed and validated before they are applied.

![D1 Safe Refactor Workflow](docs/assets/demos/d1-safe-refactor.gif)

See:

- `docs/demos/D1_SAFE_REFACTOR.md`

---

## D2 — Failure Recovery and Explainability

Demonstrates:

- validation rejection
- protected active buffers
- recovery capture
- failure diagnostics
- AI-assisted failure explanation

Failures are treated as operational events rather than hidden behaviour.

The system captures failure context and provides structured recovery information to help users understand what happened and how to proceed.

![D2 Failure Recovery Workflow](docs/assets/demos/d2-failure-recovery.gif)

See:

- `docs/demos/D2_FAILURE_RECOVERY.md`

---

## D3 — Operational Diagnostics

Demonstrates:

- runtime health validation
- workflow state visibility
- latency telemetry
- structured logging
- operational observability
- health cache behaviour

This workflow highlights one of the defining characteristics of Neovim-Codex:

System behaviour remains visible and inspectable.

Operational state is treated as a first-class concern rather than hidden implementation detail.

![D3 Operational Diagnostics](docs/assets/demos/d3-operational-diagnostics.gif)

See:

- `docs/demos/D3_OPERATIONAL_DIAGNOSTICS.md`

---

## D4 — Legacy Code Explainability

Demonstrates:

- AI-assisted code understanding
- legacy system exploration
- non-destructive analysis
- explainability workflows
- knowledge transfer

This workflow allows users to understand unfamiliar codebases without modifying source code.

It is particularly useful when working with legacy systems, inherited code, or large existing projects.

![D4 Legacy Code Explainability](docs/assets/demos/d4-legacy-explainability.gif)

See:

- `docs/demos/D4_LEGACY_EXPLAINABILITY.md`

---

## D5 — Human-in-the-Loop Engineering

Demonstrates:

- iterative refinement
- review and feedback
- explicit approval
- controlled automation
- human decision-making

Neovim-Codex is intentionally designed around a human-in-the-loop model.

AI may generate suggestions, but responsibility for engineering decisions remains with the operator.

![D5 Human-in-the-Loop Engineering](docs/assets/demos/d5-human-loop.gif)

See:

- `docs/demos/D5_HUMAN_LOOP.md`

---

# Core Workflows & Commands

## Explainability

Understand code before changing it.

- `<leader>cE`
- `:CodexExplainFailure`

## Refactoring

Generate candidate improvements safely.

- `<leader>ce`
- `<leader>cR`

## Review

Inspect generated changes before approval.

- `<leader>cd`
- `<leader>cD`

## Diagnostics

Understand system health and operational behaviour.

- `:CodexHealth`
- `:CodexState`
- `:CodexLatency`
- `:CodexCommands`

## Recovery

Treat failures as inspectable engineering events.

- `:CodexRecovery`
- `:CodexExplainFailure`

---

# Roadmap

## Platform Expansion

- Linux hardening
- Windows / WSL support
- platform abstraction layer
- reproducible installation workflows

## Engineering Workflow Expansion

- multi-language support
- enhanced explainability workflows
- advanced recovery tooling
- richer validation pipelines
- workflow automation under explicit user control

## AI Platform Integration

- OpenRouter integration
- OpenCode integration exploration
- additional model provider support

## Observability and Operations

- telemetry standardisation
- workflow analytics
- health monitoring enhancements
- operational reporting improvements

## Productisation

- standalone plugin extraction
- installation simplification
- documentation expansion
- release automation
- cross-platform release engineering

---

# Acknowledgements

Neovim-Codex exists because of the work of those who built the tools, ideas, and engineering traditions upon which it stands.

With gratitude to:

- Tim Thompson, creator of Stevie
- Bram Moolenaar, creator of Vim

The lineage from vi to Stevie, Vim, and Neovim helped establish many of the editing philosophies that continue to influence Neovim-Codex today:

- composability
- inspectability
- user control
- engineering craftsmanship

Neovim-Codex is built in that tradition.

---

# Closing Notes

Neovim-Codex represents a deliberate attempt to build AI-assisted engineering workflows that remain:

- observable
- reviewable
- deterministic
- recoverable
- traceable
- user-controlled

The system is built around three core principles:

- Correctness
- Control
- Traceability

## Ethos

The goal is not autonomous coding.

The goal is engineering confidence.

Neovim-Codex is architected as an AI-integrated engineering system rather than a generic AI editor plugin.

AI should assist engineering judgement, not replace it.

Generated output should be reviewable.

Failures should be recoverable.

System behaviour should be observable.

The human remains responsible for the decision.

The system exists to make that decision safer, clearer, and more informed.

Neovim-Codex is an ongoing exploration of how AI can strengthen engineering practice without weakening human responsibility.
