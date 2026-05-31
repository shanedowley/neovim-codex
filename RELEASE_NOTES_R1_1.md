# Neovim-Codex Release 1.1

## Overview

RC1.0 established the engineering model.

Release 1.1 improves responsiveness, visibility, and documentation.

The core principles of Neovim-Codex remain unchanged:

- Correctness
- Control
- Traceability

This release focuses on making the system faster to operate, easier to understand, and easier to work with while preserving the engineering discipline established in RC1.0.

Key themes of Release 1.1 include:

- improved responsiveness through the Stale-While-Revalidate health model
- improved visibility through workflow and health state tracking
- improved operational observability through latency instrumentation and diagnostics
- improved documentation and onboarding through a comprehensive documentation refresh

---

## Highlights

### 1. Stale-While-Revalidate Health Model

Release 1.1 introduces a Stale-While-Revalidate health model.

Startup no longer performs a blocking Codex healthcheck.

Instead, Neovim-Codex immediately displays the most recently known health state and performs real validation only when a Codex workflow is executed.

Benefits include:

- immediate Neovim usability after launch
- reduced perceived latency
- preserved runtime safety guarantees
- no compromise to execution validation

This change removes one of the most noticeable sources of startup friction while preserving the correctness guarantees of the runtime execution gate.

---

### 2. Runtime Workflow Visibility

Release 1.1 introduces a more explicit operational state model.

Users can now observe both workflow state and health state directly during operation.

Health states include:

- Unknown
- Healthcheck Running
- Ready
- Blocked

Operational states include:

- Running
- Preview
- Validating
- Applied
- Failed

Operational states always take precedence over health states.

This visibility helps users understand what the system is currently doing and why.

---

### 3. Operational Observability

Release 1.1 expands operational observability throughout the system.

Improvements include:

- latency instrumentation
- runtime timing information
- operational diagnostics
- workflow state history
- enhanced health reporting

These improvements make system behaviour easier to inspect and reason about during day-to-day use.

---

### 4. Streaming Codex Output

Release 1.1 improves the user experience of Codex operations by supporting streamed output into a single workflow buffer.

Benefits include:

- earlier visible feedback
- reduced perceived latency
- improved workflow continuity
- fewer disruptive UI transitions

The system now feels more responsive during longer-running Codex operations while maintaining existing review and safety controls.

---

### 5. Documentation Refresh

Release 1.1 includes a substantial documentation refresh.

Key updates include:

- complete README overhaul
- installation guide refresh
- architecture documentation refresh
- terminology consistency improvements
- workflow documentation improvements
- operational documentation improvements

The goal is to make the system easier to understand, easier to operate, and easier to maintain.

---

### 6. Bootstrap Modernisation

Release 1.1 modernises bootstrap tooling and release terminology.

Changes include:

- Release 1.1 bootstrap naming
- documentation consistency improvements
- release terminology cleanup
- installation workflow improvements

These changes improve consistency across the repository and align tooling with the current release.

---

## Architecture Improvements

### Stale-While-Revalidate Health Architecture

Release 1.1 introduces a Stale-While-Revalidate health model.

The previous approach required a real healthcheck to complete before the user could begin interacting with Neovim.

While operationally safe, this introduced unnecessary startup latency and reduced perceived responsiveness.

Release 1.1 separates startup responsiveness from runtime validation.

Startup now uses the most recently known health state while deferring real validation until a Codex workflow is executed.

This architecture preserves execution safety while removing healthcheck latency from the startup path.

The resulting behaviour is:

1. Neovim starts immediately.
2. The last known health state is displayed.
3. No blocking healthcheck occurs during startup.
4. A real healthcheck executes only when a Codex workflow is invoked.
5. Workflow execution is blocked if runtime validation fails.

This approach improves responsiveness without weakening correctness guarantees.

---

### Explicit State Model

Release 1.1 formalises operational state tracking.

The system now distinguishes between:

- health state
- workflow state

Health states describe the operational readiness of the system.

Workflow states describe the current activity being performed.

Health states:

- Unknown
- Healthcheck Running
- Ready
- Blocked

Workflow states:

- Running
- Preview
- Validating
- Applied
- Failed

Operational states always take precedence over health states.

This model provides a simpler and more predictable representation of system behaviour.

---

### Improved Runtime Execution Flow

Release 1.1 improves the runtime execution path for Codex operations.

Changes include:

- earlier workflow acknowledgement
- improved state transitions
- improved output streaming
- improved latency visibility
- reduced perceived wait times

The result is a workflow that feels more responsive while preserving existing safety controls and validation gates.

---

### Observability Improvements

Release 1.1 expands the operational observability capabilities of the system.

Enhancements include:

- latency instrumentation
- state transition visibility
- health state visibility
- workflow history reporting
- improved diagnostic reporting

The objective is not merely to expose metrics.

The objective is to make system behaviour understandable and inspectable by the operator.

---

## User Experience Improvements

### Faster Startup Experience

One of the primary goals of Release 1.1 was reducing startup friction.

Startup no longer waits for Codex health validation.

Neovim remains immediately usable after launch.

This change significantly improves the perceived responsiveness of the system.

---

### Improved Workflow Feedback

Release 1.1 provides earlier and more consistent feedback during workflow execution.

Users now receive:

- earlier acknowledgement that a workflow has started
- visible workflow state transitions
- streamed output during execution
- improved completion feedback

This reduces uncertainty during longer-running operations.

---

### Single-Buffer Streaming Output

Codex output is now streamed into a single workflow buffer.

Benefits include:

- reduced UI disruption
- improved continuity
- easier output review
- simpler workflow tracking

The operator can follow workflow progress in one location rather than across multiple transient views.

---

### Improved Operational Clarity

Release 1.1 places greater emphasis on making system behaviour visible.

Users can now more easily understand:

- what the system is doing
- why it is doing it
- what state it is currently in
- whether execution is permitted

This improves day-to-day usability without changing the underlying engineering philosophy.

---

## Documentation Improvements

Release 1.1 includes the largest documentation refresh undertaken by the project to date.

The objective was not simply to add more documentation.

The objective was to improve clarity, consistency, onboarding, and operational understanding.

---

### README Refresh

The project README has been substantially rewritten.

The updated README now focuses on:

- explaining what Neovim-Codex is
- defining the AI-Assisted Engineering System (AIES) concept
- describing the operational philosophy of the project
- explaining the runtime health model
- documenting workflow visibility
- improving onboarding and discovery

The README now more accurately reflects the current state and direction of the project.

---

### Installation Documentation Refresh

The installation and operations guide has been updated to align with Release 1.1.

Improvements include:

- updated bootstrap references
- updated release terminology
- improved installation guidance
- improved operational guidance
- improved first-run workflow documentation

The goal is to reduce ambiguity during setup and onboarding.

---

### Architecture Documentation Refresh

The architecture documentation has been updated to reflect the current implementation.

Key additions include:

- Stale-While-Revalidate health architecture
- workflow state model
- health state model
- runtime execution model
- operational observability concepts

The architecture guide now more closely reflects how the system actually behaves in practice.

---

### Terminology Consistency Sweep

Release 1.1 includes a repository-wide terminology review.

This work included:

- Release 1.1 naming alignment
- bootstrap naming alignment
- documentation consistency improvements
- removal of outdated release terminology from active project documentation

Historical RC1.0 documentation has been intentionally preserved where appropriate.

---

### Operational Documentation Improvements

Operational documentation has been expanded and refined.

Areas improved include:

- diagnostics
- health validation
- workflow visibility
- recovery workflows
- operational troubleshooting

The intent is to make operational behaviour easier to understand and support.

---

## Technical Debt and Known Limitations

Release 1.1 improves many aspects of system responsiveness and documentation.

However, several known limitations remain.

### Platform Support

Release 1.1 is developed and validated primarily on macOS.

Current platform status:

| Platform | Status       |
| -------- | ------------ |
| macOS    | Supported    |
| Linux    | Experimental |
| Windows  | Unsupported  |

Linux support remains an active future direction.

Windows support remains part of the longer-term cross-platform roadmap.

---

### Language Coverage

The primary engineering target remains:

- C
- C++

Additional languages may function successfully but are not yet validated to the same standard.

Examples include:

- Lua
- JavaScript
- Python
- Markdown

Broader language support remains future work.

---

### Technical Debt

The following technical debt items remain known at the time of Release 1.1:

- `vim.tbl_flatten` deprecation warning on Neovim 0.12.x
- limited large-repository validation testing
- limited Linux validation coverage
- no automated CI pipeline
- telemetry standardisation backlog items remain open

These items are tracked for future releases.

---

## Upgrade Notes

Existing users upgrading from RC1.0 should be aware of the following changes.

### Bootstrap Script Rename

The bootstrap script has been renamed:

```text
bootstrap-nvim-codex-rc1_0.sh
```

to:

```text
bootstrap-nvim-codex-r1_1.sh
```

Documentation and installation examples have been updated accordingly.

---

### Startup Behaviour Changes

Startup behaviour has changed significantly.

Users should expect:

- immediate startup usability
- no blocking startup healthchecks
- runtime validation at point-of-use

This behaviour is intentional and forms part of the Stale-While-Revalidate architecture introduced in Release 1.1.

---

### Workflow Visibility

Release 1.1 introduces explicit workflow and health state visibility.

Users may observe new status values including:

```text
? Codex Unknown
🩺 Codex Healthcheck Running
⚙ Codex Running
👁 Codex Preview
🧪 Codex Validating
✓ Codex Ready
✖ Codex Blocked
```

These states are expected and form part of the operational observability model.

---

## Looking Ahead

Release 1.1 is focused on operational maturity rather than feature expansion.

The primary objective of this release was to improve responsiveness, visibility, and documentation while preserving the engineering principles established in RC1.0.

Future development will continue to build on that foundation.

---

### Platform Expansion

Future work includes continued platform hardening and portability improvements.

Areas under consideration include:

- Linux validation and support
- platform abstraction improvements
- reproducible environment provisioning
- installation simplification
- future Windows and WSL evaluation

The long-term goal is to maintain consistent behaviour across supported platforms while preserving operational guarantees.

---

### Engineering Workflow Expansion

Future releases may expand supported engineering workflows.

Areas of interest include:

- additional language support
- enhanced explainability workflows
- richer validation pipelines
- improved recovery tooling
- expanded testing workflows
- workflow automation under explicit user control

Any future workflow expansion will continue to operate within the principles of Correctness, Control, and Traceability.

---

### Observability and Operations

Release 1.1 significantly expands observability.

Future work may include:

- telemetry standardisation
- latency reporting improvements
- operational analytics
- health monitoring enhancements
- workflow reporting improvements

The objective is to improve understanding of system behaviour without introducing unnecessary complexity.

---

### AI Platform Integration

Future releases may explore broader AI platform support.

Areas currently under consideration include:

- OpenRouter integration
- OpenCode integration
- multi-provider AI support
- provider abstraction improvements

These investigations are intended to improve flexibility while preserving existing workflow guarantees.

---

### Productisation

The project continues to evolve from a personal engineering environment toward a more broadly consumable engineering system.

Future productisation work may include:

- installation improvements
- release automation
- documentation expansion
- contributor experience improvements
- repository hardening
- cross-platform release engineering

The objective is not to increase automation for its own sake.

The objective is to improve usability while preserving engineering discipline.

---

## Acknowledgements

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

## Closing Notes

RC1.0 established the engineering model.

Release 1.1 improves responsiveness, visibility, and documentation.

The core principles remain unchanged:

- Correctness
- Control
- Traceability

Release 1.1 focuses on making the system:

- faster
- easier to understand
- easier to operate

while preserving the engineering discipline that defines the project.

Neovim-Codex continues to explore a simple idea:

AI can strengthen engineering workflows without replacing engineering judgement.

The human remains responsible for the decision.

The system exists to help make that decision safer, clearer, and more informed.
