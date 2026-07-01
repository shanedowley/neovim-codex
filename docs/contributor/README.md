# Neovim-AIDE Contributor Guide

Welcome to the Neovim-AIDE Contributor Guide.

Thank you for your interest in contributing to the project.

Neovim-AIDE is an open source IDE project built on a simple principle:

> **Human-controlled. AI-assisted.**

AI should assist software engineers, not replace them.

Whether you are fixing a bug, improving the documentation, refining the user experience or contributing new functionality, you are helping to build a better software engineering environment for the entire community.

---

# Engineering Principles

Neovim-AIDE is built around a small number of long-term engineering principles.

These principles influence every technical decision, engineering workflow and contributor experience.

## Human-Controlled AI

AI assists developers and engineers.

Developers and engineers make decisions.

Neovim-AIDE deliberately avoids hidden automation in favour of explicit operations, observable behaviour and human judgement.

---

## Correctness Before Convenience

Safe engineering outcomes take precedence over automation.

Reliability, predictability and confidence are valued more highly than feature velocity.

---

## Explicit Over Implicit

Operations should be intentional and visible.

Users should understand what the system is doing, when it is doing it and why.

---

## Observable Systems

Reliable software is observable software.

Health, workflow state, diagnostics, logging and validation exist to make system behaviour visible rather than hidden.

---

## Sandbox-First Validation

All new functionality should be validated inside the isolated development sandbox before it is considered complete.

A contributor's personal Neovim configuration is a development environment.

The sandbox is the release validation environment.

---

## Reproducible Engineering

Engineering practices should be repeatable by every contributor.

The project values reproducible workflows over environment-specific behaviour.

---

# Engineering Workflow

Every contribution should follow the same engineering workflow.

```text
Observe
    ↓
Analyse
    ↓
Design
    ↓
Implement
    ↓
Validate
    ↓
Commit
    ↓
Sandbox Validation
    ↓
Review
```

Small, independently testable changes are preferred over large feature branches.

Whenever practical, each story should leave the project in a working, releasable state.

Engineering confidence is built through incremental progress and continuous validation.

---

# Repository Workflow

Contributions typically follow this lifecycle.

```text
Issue / Idea
      ↓
Understand the Problem
      ↓
Design the Change
      ↓
Implement
      ↓
Validate Locally
      ↓
Validate in Sandbox
      ↓
Commit
      ↓
Review
      ↓
Merge
```

Keeping each contribution focused makes review easier and reduces the risk of regressions.

---

# Contributor Documentation

Additional contributor documentation is organised into focused guides.

| Guide        | Purpose                                                      |
| ------------ | ------------------------------------------------------------ |
| `SANDBOX.md` | Sandbox setup, validation workflow and release verification. |

As the project grows, additional contributor guides may be added.

Each guide should have a single, well-defined responsibility and avoid duplicating information maintained elsewhere.

---

# Getting Started

If you are contributing to Neovim-AIDE for the first time, the recommended reading order is:

1. Read this guide.
2. Read `SANDBOX.md`.
3. Explore the repository.
4. Choose a small improvement or issue.
5. Validate your changes locally.
6. Validate your changes in the sandbox.
7. Submit your contribution.

---

# Contributing

Contributions of all kinds are welcome, including:

- bug fixes
- documentation improvements
- workflow enhancements
- user experience improvements
- testing and validation
- performance improvements
- engineering discussions
- ideas for future development

Thoughtful discussion, careful engineering and incremental improvement are valued more highly than rapid feature development.

---

# Building Neovim-AIDE Together

Neovim-AIDE is more than a collection of plugins.

It is a software development IDE built around correctness, control and traceability.

Every contribution helps make the project more reliable, more understandable and more valuable for the engineers who use it.

Thank you for helping build Neovim-AIDE.

