# D3 — Operational Diagnostics Workflow Demo

## Purpose

Demonstrates the operational observability and diagnostics capabilities of Neovim-AIDE.

This demo focuses on:

- system introspection
- workflow state visibility
- operational diagnostics
- latency telemetry
- structured operational logging
- engineering-grade observability

The purpose of this workflow is to demonstrate that Neovim-AIDE behaves as an inspectable engineering system rather than a black-box AI workflow.

---

# Demo Asset

![D3 Operational Diagnostics](../assets/demos/d3-operational-diagnostics.gif)

MP4 source:

```text
docs/assets/demos/d3-operational-diagnostics.mp4
```

---

# Commands Demonstrated

The demo includes:

```vim
:CodexHealth
:CodexStateHistory
:CodexState
:CodexLatency
:CodexLog
```

These commands expose different operational aspects of the Neovim-AIDE system.

---

# Operational Focus

## Health Diagnostics

```vim
:CodexHealth
```

Demonstrates:

- dependency validation
- runtime verification
- module loading checks
- prompt system validation
- operational readiness checks

---

## Workflow State Visibility

```vim
:CodexState
:CodexStateHistory
```

Demonstrates:

- current workflow state
- recent workflow transitions
- operational traceability
- visible workflow lifecycle behaviour

---

## Latency Telemetry

```vim
:CodexLatency
```

Demonstrates:

- operation timing
- recent execution telemetry
- PASS/FAIL latency tracking
- observable workflow performance

---

## Structured Operational Logging

```vim
:CodexLog
```

Demonstrates:

- structured event logging
- operational event tracing
- workflow auditability
- observable execution history

---

# Session Preparation

Prior to recording, lightweight Codex operations were executed in order to populate:

- workflow state history
- latency telemetry
- operational log entries

This ensures the diagnostics views contain meaningful operational data during the demonstration.

---

# Acceptance Criteria

This demo passes if it visibly demonstrates:

- successful operational health checks
- populated workflow state history
- readable workflow state information
- recent latency telemetry
- structured operational logging
- observable workflow introspection

The demo should communicate:

- operational clarity
- engineering discipline
- traceability
- diagnosability
- system introspection

rather than AI automation or “magic”.

---

# Key Message

Neovim-AIDE treats operational observability as a first-class engineering concern.

The system is intentionally designed to expose:

- validation behaviour
- operational state
- latency telemetry
- execution history
- workflow transitions
- recovery information

This operational visibility is part of the core design philosophy of the Neovim-AIDE AI-Assisted Software Engineering Environment.
