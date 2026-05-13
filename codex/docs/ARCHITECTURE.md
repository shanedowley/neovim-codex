# ARCHITECTURE.md

## Neovim-Codex RC1.0 — Architecture Overview

---

# 1. Purpose

This document defines the high-level architectural boundaries of the Neovim-Codex RC1.0 system.

The goal is to distinguish:

- the Neovim-Codex AI-Assisted Engineering System (AIES)
- the surrounding Neovim engineering environment
- operational ownership boundaries
- supported RC1.0 system responsibilities

---

# 2. Architectural Positioning

Neovim-Codex RC1.0 is released as:

> A curated engineering environment centred around the Neovim-Codex AI-Assisted Engineering System.

The repository is intentionally broader than a single isolated Neovim plugin.

The Neovim-Codex subsystem is the primary architectural focus of the repository.

Supporting Neovim tooling exists to provide a coherent and operationally effective engineering environment around that subsystem.

---

# 3. Core System Boundary

The following areas constitute the core Neovim-Codex system.

These components are part of the RC1.0 architectural contract.

## Core Runtime

```text
lua/codex/
lua/codex_cli.lua
lua/codex_guard.lua
lua/codex_log.lua
lua/codex_memory.lua
lua/codex_mode.lua
lua/codex_parse.lua
lua/codex_prompt.lua
lua/codex_recovery.lua
lua/codex_setup.lua
lua/ui_notify.lua
```

---

# 4. Core Prompt System

```text
codex/prompts/
```

This subsystem defines:

- rewrite prompts
- apply prompts
- explain prompts
- entire-file rewrite prompts
- unified diff prompts

Prompt versioning and prompt observability are core architectural behaviours.

---

# 5. Core Documentation

```text
codex/docs/
```

This documentation defines:

- operational behaviour
- release scope
- workflow commands
- architecture boundaries
- repository audit decisions

The documentation is part of the operational contract of the RC1.0 system.

---

# 6. Core System Responsibilities

The Neovim-Codex subsystem is responsible for:

- Codex workflow orchestration
- rewrite execution
- preview/apply flows
- validation enforcement
- workflow state tracking
- operational logging
- latency tracking
- recovery capture
- failure explanation
- prompt management
- context injection
- operational diagnostics

These systems collectively form the operational safety and observability layer of Neovim-Codex RC1.0.

---

# 7. Supporting IDE Environment

The repository also contains a broader Neovim engineering environment.

These components support the operational usability of the system but are not themselves part of the Neovim-Codex architectural core.

Examples include:

```text
lua/plugins/
lua/keymaps/
lua/snippets/
lua/themes/
after/
```

These provide:

- editor UX
- syntax support
- debugger integration
- navigation tooling
- completion systems
- formatting systems
- Git workflows
- terminal workflows
- session management
- theme management

The repository intentionally ships as a complete engineering environment rather than a minimal isolated plugin.

---

# 8. Ownership Boundary

RC1.0 support guarantees primarily apply to:

- Neovim-Codex workflows
- observability systems
- validation systems
- recovery systems
- operational tooling
- C/C++ engineering workflows

General Neovim customisation components may evolve independently and may not carry equivalent operational guarantees.

This distinction exists to separate:

- the operationally supported Neovim-Codex subsystem
- the broader surrounding editor environment

---

# 9. Design Philosophy

This Neovim-Codex architecture intentionally favours:

- explicit workflows
- inspectable behaviour
- operational visibility
- deterministic execution
- recoverable failure handling
- modular subsystem separation

The project intentionally avoids:

- opaque automation
- hidden background mutation
- autonomous repository rewriting
- silent workflow execution

Neovim-Codex is designed as a disciplined engineering workflow system rather than an autonomous AI coding environment.

The user remains explicitly responsible for accepting or rejecting any meaningful code changes.

---

# 10. Future Direction

Future releases may evolve toward:

- stronger subsystem modularisation
- standalone plugin extraction
- broader language support
- Linux hardening
- Windows/WSL support
- CI validation pipelines
- packaging improvements

However RC1.0 intentionally prioritises:

- operational coherence
- engineering safety
- architectural clarity
- real-world usability
- disciplined workflow behaviour

The immediate RC1.0 goal is to establish a stable, observable and operationally credible AI-assisted engineering environment suitable for serious daily usage.
