# RELEASE_SCOPE_RC1_0.md, draft v2

## Neovim-Codex RC1.0 — Release Scope

---

# 1. Project Positioning

Neovim-Codex is an AI-Assisted Engineering System (AIES) for Neovim.

The system is designed around:

- correctness
- explicit operator control
- observability
- validation
- recoverability
- deterministic engineering workflows

The project intentionally prioritises safe, inspectable engineering workflows over autonomous behaviour or automation.

Neovim-Codex is not an “AI autopilot”.

The user remains in control of all meaningful code changes.

---

# 2. RC1.0 Definition

RC1.0 represents the first operationally credible public release candidate of the system.

The release target is:

- for stable daily engineering usage
- reproducible installation
- observable workflow execution
- safe preview/apply flows
- operational diagnostics
- recoverable failure handling
- explicit workflow state visibility

RC1.0 is considered:

- operationally usable
- architecturally coherent
- safety-oriented
- internally dogfooded

RC1.0 is not:

- feature complete
- fully cross-platform
- fully language-agnostic
- enterprise-hardened

---

# 3. Supported Platforms

## Officially Supported

### macOS

Primary development and validation platform.

All workflows, bootstrap tooling, operational validation, and release testing are currently centred on macOS.

Expected target environment:

- Homebrew
- Neovim 0.10+
- POSIX shell environment
- clang toolchain
- Git
- Node/npm
- Codex CLI

---

## Partial Support

### Linux

Linux support is planned and partially architected through POSIX-oriented design choices.

However it is not yet considered fully validated for RC1.0.

Differences between distributions, package layouts, shell environments, and toolchain paths may require manual adjustment.

---

## Unsupported

### Windows

Native Windows support is out of scope for RC1.0.
WSL support may be explored in future releases.

---

# 4. Supported Languages

## Primary / Validated

### C / C++

Primary engineering target for RC1.0.

Supported capabilities include:

- rewrite workflows
- preview/apply workflows
- clang validation
- safe refactor workflows
- latency tracking
- operational logging
- workflow recovery

---

## Secondary / Supported

### Lua

Lua support exists primarily to support Neovim configuration and Neovim-Codex system development.
Most workflows operate correctly for Lua-based editing.

---

## Not Fully Yet Validated

### JavaScript

### Python

### Markdown

### General text workflows

These workflows may function successfully but are not considered fully validated engineering targets for RC1.0.
Validation guarantees may be reduced outside C/C++ workflows.

---

# 5. Supported Workflows

RC1.0 officially supports:

- inline rewrite workflows
- selection rewrite workflows
- safe preview → confirm → apply workflows
- explain workflows
- scratchpad workflows
- operational health diagnostics
- workflow state inspection
- latency inspection
- failure recovery inspection
- failure explanation workflows
- prompt version inspection
- project context injection
- operational logging

---

# 6. Safety Guarantees

Neovim-Codex is designed around explicit safety constraints.

RC1.0 guarantees:

## Human-reviewed changes

No automatic code application occurs without explicit user confirmation in preview workflows.

---

## Validation before apply

C/C++ rewrites pass through clang validation before change is committed to the active buffer.

---

## Observable execution

Operational activity is logged and inspectable.

This includes:

- prompts
- workflow transitions
- validation results
- latency events
- failures
- apply events

---

## Recoverable failure handling

Failures are captured into structured recovery reports.

Failures are inspectable after workflow termination.

---

## No hidden background automation

The system does not autonomously change repositories, create commits, push changes, or execute0 hidden workflows.

---

# 7. Explicit Non-Goals

The following are intentionally out of scope for RC1.0:

- autonomous coding agents
- silent code changes
- background repository rewriting
- auto-commit workflows
- cloud orchestration
- remote telemetry collection
- multi-user collaboration systems
- enterprise fleet management
- AI-driven repository indexing
- autonomous planning systems
- agent swarms
- hidden prompt injection or execution

---

# 8. Deferred Features

The following areas are intentionally deferred beyond RC1.0:

- Windows support
- broader Linux validation
- multi-language engineering parity
- remote execution workflows
- plugin marketplace integration
- distributed agent systems
- cloud-hosted orchestration
- advanced telemetry analytics
- full session replay systems
- automated benchmark infrastructure
- advanced workflow visualisation
- integrated testing dashboards

---

# 9. Known Limitations

Current known limitations include:

- macOS-centric validation
- limited external contributor testing
- limited large-repository stress testing
- partial Linux validation
- limited non-C/C++ validation guarantees
- operational UX still evolving
- documentation still expanding
- no formal semantic versioning process yet
- no automated CI pipeline yet

---

# 10. Release Philosophy

Neovim-Codex is intentionally designed as a disciplined engineering system rather than an autonomous AI coding environment.

The core philosophy is:

- correctness over convenience
- explicit control over hidden automation
- observability over opacity
- recovery over silent failure
- engineering discipline over “AI magic”

The project aims to provide a trustworthy AI-assisted engineering workflow that remains understandable, inspectable, and user-controlled.
