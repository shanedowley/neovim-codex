# Neovim-AIDE Contributor Guide

Welcome to the Neovim-AIDE Contributor Guide.

Thank you for your interest in contributing to the project.

Neovim-AIDE is an open source project built on the belief that AI should **assist** software engineers, not replace them. Every design decision is guided by the principle that engineers remain in control while AI augments their capability.

Whether you are fixing a bug, improving the documentation, refining the user experience or contributing new functionality, you are helping to build a better engineering environment for the entire community.

---

# Project Identity

## Neovim-AIDE

### *An AI-Assisted Software Engineering Environment for Neovim.*

**Human-controlled. AI-assisted.**

Built for:

- **Correctness**
- **Control**
- **Traceability**

These values guide both the product itself and the way the project is engineered.

---

# Project Principles

Neovim-AIDE is built around a small number of long-term engineering principles.

These principles influence every technical decision, engineering workflow and contributor experience.

## Human-Controlled AI

AI assists engineers.

Engineers make decisions.

Neovim-AIDE deliberately avoids hidden automation in favour of explicit operations, observable behaviour and human judgement.

---

## Explicit Over Implicit

Operations should be intentional and visible.

Users should understand what the system is doing and when it is doing it.

---

## Observable Systems

Reliable software is observable software.

Health, workflow state, recovery information, logging and validation exist to make the behaviour of the system visible rather than hidden.

---

## Deterministic Behaviour

The same operation should produce the same outcome when performed under the same conditions.

Reducing uncertainty improves both engineering confidence and release quality.

---

## Sandbox-First Validation

All new functionality must be validated inside the isolated development sandbox before it is considered complete.

A contributor's personal Neovim configuration is a development environment.

The sandbox is the release validation environment.

---

## Reproducible Engineering

Engineering practices should be repeatable by every contributor.

The project values reproducible workflows over environment-specific behaviour.

---

# Contributor Workflow

Every contribution should follow the same engineering workflow.

```text
Understand
    │
    ▼
Design
    │
    ▼
Implement
    │
    ▼
Local Smoke Test
    │
    ▼
Commit
    │
    ▼
Sandbox Validation
    │
    ▼
Regression Testing
    │
    ▼
Review
```

Small, independently testable changes are preferred over large feature branches.

Whenever possible, each story should leave the project in a working, releasable state.

---

# Contributor Documentation

Additional contributor documentation is organised into focused guides.

| Guide | Purpose |
|-------|---------|
| `SANDBOX.md` | Isolated development and release validation |
| *(Future)* Testing | Regression testing strategy |
| *(Future)* Release | Release workflow and checklists |
| *(Future)* Architecture | High-level project architecture |
| *(Future)* Coding Standards | Engineering conventions and project style |

Each document has a single responsibility and links to related material where appropriate.

---

# Getting Started

If you are contributing to Neovim-AIDE for the first time, the recommended reading order is:

1. This guide.
2. `SANDBOX.md`
3. Explore the project.
4. Choose a small story or improvement.
5. Validate your work in the sandbox.
6. Submit your contribution.

---

# Contributing

Contributions of all kinds are welcome.

Examples include:

- Feature development
- Bug fixes
- Documentation improvements
- User experience enhancements
- Testing and validation
- Performance improvements
- Engineering discussions
- Project ideas

Thoughtful discussion, careful engineering and incremental improvement are valued more highly than rapid feature development.

---

# Building Neovim-AIDE Together

Neovim-AIDE is more than a collection of plugins.

It is an engineering environment built around correctness, control and traceability.

Every contribution helps make the project more reliable, more understandable and more valuable for the engineers who use it.

Thank you for helping build Neovim-AIDE.