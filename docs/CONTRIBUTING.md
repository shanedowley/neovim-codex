# Contributing

# Contributing to Neovim-AIDE

Thank you for taking an interest in contributing to Neovim-AIDE.

Neovim-AIDE is an **AI-Assisted Software Engineering Environment for Neovim**.

The project is built around a simple principle:

> **Human-controlled. AI-assisted.**

We welcome contributions that improve the reliability, maintainability and usability of the project while preserving its core engineering philosophy.

---

# Project Philosophy

Neovim-AIDE is intentionally designed as an engineering environment rather than an autonomous AI coding system.

The project prioritises:

- correctness
- explicit user control
- operational visibility
- validation
- traceability
- maintainability

The architecture assumes:

- AI-generated code can be incorrect.
- Development environments can degrade.
- Engineers should remain in control of decisions.
- AI should assist engineering workflows rather than replace them.

Features that reduce visibility, bypass validation or introduce opaque automation are unlikely to align with the goals of the project.

---

# Engineering Workflow

Neovim-AIDE has been developed using a disciplined, incremental engineering process.

Contributors are encouraged to follow the same approach.

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
```

In practice this means:

- understand the problem before proposing a solution
- make small, focused changes
- complete one story at a time
- avoid speculative refactoring
- validate behaviour before merging
- prefer incremental improvement over large rewrites

Engineering confidence is valued more highly than feature velocity.

---

# Contribution Scope

Contributions are welcome in areas including:

- documentation
- workflow improvements
- operational observability
- runtime validation
- installation and bootstrap
- testing
- diagnostics
- Neovim UX improvements
- platform compatibility
- maintainability

Small, focused and reviewable pull requests are strongly preferred.

---

# Sandbox-First Validation

All changes should be validated before they are merged.

Where practical, contributors are encouraged to validate changes using an isolated sandbox environment before testing within their primary development environment.

The typical workflow is:

```text
Develop
    ↓
Validate in Sandbox
    ↓
Verify Behaviour
    ↓
Submit
```

Sandbox-first validation helps identify installation issues, dependency problems and behavioural regressions before they reach other users.

---

# Code Style

The project values code that is easy to understand and maintain.

General guidelines include:

- prefer readability over cleverness
- keep functions focused
- minimise unnecessary complexity
- favour explicit behaviour over hidden side effects
- use descriptive names
- follow existing project conventions

Consistency with the surrounding codebase is generally more important than individual coding style.

---

# Testing and Validation

Contributors should verify that changes behave as intended before submitting them.

Depending on the nature of the change, this may include:

- runtime validation
- bootstrap verification
- workflow testing
- preview and apply behaviour
- logging and diagnostics
- failure-path testing

Documentation updates should accompany behavioural or architectural changes where appropriate.

---

# Safety Expectations

Neovim-AIDE deliberately favours explicit engineering workflows over autonomous behaviour.

Contributions should preserve that philosophy.

In particular:

- preserve explicit user confirmation
- avoid silent source-code modification
- avoid hidden background automation
- maintain workflow visibility
- preserve validation before application

Operational visibility is considered a feature rather than an implementation detail.

---

# Pull Request Expectations

Good pull requests are:

- focused
- incremental
- well described
- technically justified
- appropriately documented
- validated before submission

Large pull requests that combine unrelated changes are more difficult to review and are generally discouraged.

---

# Documentation

Documentation is considered part of the product rather than an afterthought.

Contributors making behavioural or architectural changes should update relevant documentation where appropriate.

Commonly updated documents include:

- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/README.md`
- user-facing help
- installation documentation

Documentation should remain:

- technically accurate
- concise
- practical
- welcoming
- consistent with the shipped product

---

# What Not To Submit

The following types of changes are unlikely to align with the goals of the project:

- autonomous coding workflows
- silent auto-apply behaviour
- hidden background mutation
- opaque automation
- unnecessary architectural complexity
- features that reduce user control

Neovim-AIDE deliberately favours explicit engineering over invisible automation.

---

# Community

Constructive discussion, thoughtful engineering trade-offs and respectful collaboration are encouraged.

Questions, ideas and well-reasoned proposals are always welcome.

The best contributions are those that improve the project while preserving its guiding principles:

- Correctness
- Control
- Traceability

**Human-controlled. AI-assisted.**