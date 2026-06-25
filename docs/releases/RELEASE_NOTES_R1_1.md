# Current Release 1.1 Scope

Release 1.1 focuses on strengthening Neovim-Codex as an AI-Assisted Engineering System (AIES).

The primary goals of Release 1.1 are:

- improved operational observability
- improved runtime responsiveness
- improved workflow visibility
- improved diagnostics
- improved recovery behaviour
- stronger documentation
- improved user confidence

## Core Areas

Release 1.1 focuses on:

- macOS
- Neovim
- C/C++ engineering workflows
- AI-assisted code explainability
- safe AI-assisted refactoring
- runtime health validation
- workflow state visibility
- structured operational telemetry
- latency instrumentation
- failure recovery workflows
- human-in-the-loop engineering

## Runtime Health Model

Release 1.1 introduces a Stale-While-Revalidate health model.

Startup never performs a blocking healthcheck.

Neovim remains immediately usable.

Health validation occurs only at point-of-use when a Codex workflow is executed.

This design improves responsiveness while preserving execution safety.

## Workflow Visibility

Release 1.1 introduces visible workflow and health states.

```text
? Codex Unknown
🩺 Codex Healthcheck Running
⚙ Codex Running
👁 Codex Preview
🧪 Codex Validating
✓ Codex Ready
✖ Codex Blocked
```

Operational states always take precedence over health states.

This visibility forms part of the observability model of the system.

## Human-in-the-Loop Engineering

Generated output is:

- reviewable
- inspectable
- recoverable
- approval-gated

No silent apply path exists.

Human judgement remains part of the workflow.

## Out of Scope

The following areas remain future work:

- Windows support
- broader language support
- multi-provider AI backends
- OpenRouter integration
- OpenCode integration
- cloud-assisted workflows
- advanced workflow automation
