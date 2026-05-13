# D4 — Legacy Code Explainability Demo

## Purpose

Demonstrates how Neovim-Codex can assist engineers in understanding existing C code without modifying it.

This demo focuses on:

- legacy-style code comprehension
- bitmask and flag interpretation
- control-flow reasoning
- edge-case explanation
- safe read-only AI assistance

The workflow demonstrates AI-assisted reasoning rather than AI-driven code generation.

---

# Demo Asset

![D4 Legacy Explainability](../assets/demos/d4-legacy-explainability.gif)

MP4 source:

```text
docs/assets/demos/d4-legacy-explainability.mp4
```

---

# Scenario

The demo uses a small C workflow containing:

- bitmask flags
- conditional execution logic
- retry handling
- guarded control flow

The following function is selected and explained:

```c
static int should_process_job(JobState job)
```

The workflow focuses on understanding:

- flag interpretation
- processing conditions
- rejection paths
- retry edge cases

without changing the source code.

---

# Prompt Used

```text
Explain this function clearly. Focus on the flags, control flow, and edge cases. Do not rewrite the code.
```

---

# Operational Focus

This demo intentionally demonstrates:

- explanation workflows
- engineering reasoning support
- safe read-only operation
- understanding existing systems
- AI-assisted comprehension

rather than automated code rewriting.

No source mutation occurs during this workflow.

---

# Acceptance Criteria

This demo passes if it visibly demonstrates:

- clear explanation of flag logic
- explanation of control flow
- explanation of edge cases
- no source modification
- stable explain workflow behaviour
- readable explanation output

The workflow should communicate:

- safe reasoning assistance
- explainability
- engineering comprehension support
- operational restraint

rather than autonomous code generation.

---

# Key Message

Neovim-Codex is designed to assist engineers in understanding existing systems safely and inspectably.

The system is intentionally capable of supporting:

- reasoning about legacy code
- understanding control flow
- interpreting conditional logic
- explaining low-level engineering behaviour

without requiring automatic rewriting or mutation of the active source buffer.

This workflow demonstrates AI assistance as an engineering reasoning tool rather than a replacement for engineering judgement.
