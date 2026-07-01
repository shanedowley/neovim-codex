# Architecture

# Neovim-AIDE Architecture

Neovim-AIDE is an AI-Assisted IDE for Neovim.

This document describes the architecture of the shipped system, the responsibilities of its major runtime subsystems, and the engineering principles that guide their design.

The architecture is intentionally conservative. Rather than maximising automation, it emphasises correctness, explicit control and operational visibility.

---

# Architectural Principles

The design of Neovim-AIDE is guided by a small number of engineering principles.

## Correctness

Safe engineering outcomes take precedence over automation.

## Control

Developers remain responsible for engineering decisions. AI assists the workflow but does not replace human judgement.

## Traceability

Workflow execution should be be observable, understandable and diagnosable.

## Operational Visibility

The system should make its current state, progress and failures visible rather than hiding them behind background automation.

## Human-controlled. AI-assisted.

AI is treated as an engineering tool operating within explicit workflows rather than an autonomous agent.

---

# Architectural Overview

Neovim-AIDE consists of a set of cooperating runtime subsystems.

Each subsystem has a clearly defined responsibility.

```text
                  User
                    │
          Commands / Keymaps
                    │
             Workflow Layer
                    │
         Prompt Construction
                    │
        Runner & Preflight Checks
                    │
      Runtime Health Validation
                    │
          AI Model Execution
                    │
     Report & Preview Generation
                    │
 Validation & Explicit Confirmation
                    │
            Apply Changes
                    │
 Logging • Runtime State • Metrics
```

The architecture intentionally provides a single, predictable workflow regardless of the AI-assisted operation being performed.

---

# Runtime Workflow

Every AI-assisted workflow follows the same execution lifecycle.

```text
User Request
      ↓
Construct Prompt
      ↓
Runner Preflight
      ↓
Runtime Health Check
      ↓
Execute AI Request
      ↓
Generate Report
      ↓
Preview Changes
      ↓
Validate
      ↓
Explicit Confirmation
      ↓
Apply Changes
```

This common lifecycle keeps behaviour predictable, simplifies debugging and makes operational state easy to understand.

---

# Core Runtime Subsystems

Neovim-AIDE is organised as a collection of focused runtime subsystems.

Each subsystem has a single primary responsibility and communicates with neighbouring subsystems through well-defined workflow boundaries.

This separation keeps the architecture understandable, maintainable and testable.

---

## Workflow

The workflow subsystem provides the user-facing entry point into Neovim-AIDE.

It is responsible for initiating AI-assisted operations and coordinating the overall execution lifecycle.

Responsibilities include:

- user commands
- key mappings
- workflow orchestration
- lifecycle coordination

---

## Prompt Construction

Prompt construction transforms user intent into structured prompts suitable for AI execution.

Responsibilities include:

- prompt templates
- instruction construction
- source context
- language context
- prompt versioning

---

## Runner

The runner is the central orchestration component.

It coordinates execution from preflight validation through completion and ensures that workflow stages execute in the correct order.

Responsibilities include:

- workflow orchestration
- execution scheduling
- preflight validation
- execution coordination
- failure handling

---

## Runtime Health

The runtime health subsystem determines whether AI workflows can execute safely.

Neovim-AIDE uses a **Stale-While-Revalidate** health model.

At startup, the most recently known health state is loaded from persistent cache, allowing Neovim to become immediately usable without blocking startup.

Whenever an AI workflow is invoked, a complete runtime health check is performed before execution proceeds.

Responsibilities include:

- dependency validation
- environment verification
- persistent health cache
- execution gating
- health reporting

This approach combines fast startup with mandatory runtime validation.

---

## Runtime State

Runtime state provides visibility into both environment readiness and workflow execution.

Two complementary state models are maintained.

### Health State

Health state describes whether the environment is capable of safely executing AI-assisted workflows.

Typical states include:

- Unknown
- Health Check Running
- Ready
- Blocked

### Operational State

Operational state reflects the current workflow lifecycle.

Typical states include:

- Running
- Preview
- Validating
- Applied
- Failed

Operational state always takes precedence while a workflow is active, ensuring the user sees the most relevant information.

---

## AI Execution

The AI execution subsystem delegates model interaction to the configured AI provider.

The remainder of the system is insulated from provider-specific implementation details, allowing execution behaviour to evolve independently from workflow orchestration.

Responsibilities include:

- process execution
- asynchronous communication
- response collection
- execution abstraction

---

## Report Windows

Report windows provide consistent operational feedback throughout workflow execution.

Rather than exposing raw command output, Neovim-AIDE presents structured reports that explain the current operation, its outcome and any required user action.

Examples include:

- health reports
- validation reports
- execution summaries
- diagnostics

This provides a consistent user experience across all workflows.

---

## Preview

The preview subsystem presents generated changes before they are applied.

Responsibilities include:

- unified diff generation
- review interface
- confirmation workflow

No silent apply path exists.

---

## Validation

Validation provides confidence that generated changes are suitable for application.

Depending on the workflow, validation may include:

- syntax validation
- constrained refactoring
- language-aware analysis

Validation exists to reduce incorrect or unsafe modifications before they reach the user's project.

---

## Apply

The apply subsystem performs controlled modification of project files.

Changes are applied only after successful completion of the workflow lifecycle and explicit user confirmation.

The architecture intentionally avoids autonomous source-code modification.

---

## Observability

Operational observability is treated as part of the system architecture rather than an implementation detail.

Responsibilities include:

- structured logging
- latency instrumentation
- workflow tracing
- diagnostics
- operational metrics

These capabilities support debugging, troubleshooting and performance analysis.

---

## Bootstrap

Bootstrap prepares a new environment for reliable operation.

Responsibilities include:

- dependency verification
- installation validation
- runtime directory validation
- configuration checks

Development follows a **sandbox-first validation** philosophy.

Changes are validated in isolated environments before they are merged or released, helping ensure reproducible installations and reducing regression risk.

---

# Runtime Model

Neovim-AIDE separates configuration, runtime state, cache and operational data in accordance with the XDG Base Directory Specification.

This separation improves:

- maintainability
- reproducibility
- troubleshooting
- operational hygiene

Runtime-generated artefacts are intentionally kept outside the configuration directory.

---

# Repository Structure

The repository broadly mirrors the architectural organisation of the runtime.

```text
bootstrap.sh

lua/
    aide/
        workflow.lua
        runner.lua
        health.lua
        state.lua
        preview.lua
        prompt.lua
        validation.lua
        report.lua
        cli.lua
        log.lua

docs/
tests/
demo/
```

Each major runtime subsystem is implemented as a focused module with a single primary responsibility.

This alignment between architecture and implementation helps contributors navigate the codebase while reducing architectural drift over time.

---

# Safety Model

Neovim-AIDE is intentionally designed to favour explicit engineering workflows over autonomous behaviour.

Safety mechanisms include:

- runtime health validation
- preview-before-apply
- validation-before-apply
- explicit user confirmation
- structured operational logging
- observable workflow state

The architecture assumes:

- AI-generated code can be incorrect.
- Development environments can degrade.
- Human review remains essential.

---

# Architectural Non-Goals

Neovim-AIDE is intentionally **not** designed to become:

- an autonomous coding agent
- an invisible background automation system
- a zero-review code generator
- a fully automatic source-code mutator

The architecture deliberately favours explicit interaction over hidden automation.

---

# Summary

Neovim-AIDE is an AI-Assisted IDE built around structured workflows, runtime validation and explicit developer control.

Its architecture combines workflow orchestration, runtime health validation, operational visibility and user approval into a coherent engineering model.

The guiding principles remain unchanged:

- Correctness
- Control
- Traceability

**Human-controlled. AI-assisted.**

