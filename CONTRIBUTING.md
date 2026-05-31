# CONTRIBUTING.md

# Contributing to Neovim-Codex

Thank you for taking an interest in contributing to Neovim-Codex.

This project is intentionally developed as an AI-Assisted Engineering System (AIES) focused on:

- correctness
- explicit user control
- observability
- validation
- recoverability
- deterministic engineering workflows

Contributions should reinforce those principles rather than weaken them.

---

# Project Philosophy

Neovim-Codex is intentionally designed as an engineering system rather than an autonomous AI coding environment.

The project prioritises:

- inspectable workflows
- explicit preview/apply behaviour
- validation-aware operations
- operational diagnostics
- recoverable failures
- user-controlled execution

Features that reduce visibility, bypass validation, or introduce opaque automation are unlikely to align with the goals of the project.

---

# Contribution Scope

Contributions are welcome in areas including:

- operational hardening
- workflow observability
- validation systems
- recovery systems
- prompt management
- documentation
- platform portability
- Neovim UX improvements
- test coverage
- bootstrap and reproducibility improvements

Small, focused, reviewable pull requests are strongly preferred.

---

# Safety Expectations

Contributions should preserve the core AIES principles:

- correctness
- explicit user control
- observability
- validation
- recoverability

In particular:

- avoid silent mutation workflows
- avoid hidden automation
- avoid background repository rewriting
- avoid autonomous apply behaviour
- preserve explicit confirmation flows wherever possible

Operational visibility is considered a feature, not an inconvenience.

---

# Code Style

The project currently prioritises:

- readability
- operational clarity
- explicit naming
- simple control flow
- maintainability over cleverness

Consistency with the surrounding codebase is preferred over stylistic purity.

---

# Testing and Validation

Where practical, contributions should include:

- validation steps
- operational verification
- reproducible behaviour
- failure-path consideration

For workflow-related changes, contributors are encouraged to verify:

- logging behaviour
- workflow state transitions
- validation behaviour
- recovery handling
- preview/apply flows

---

# Documentation Expectations

Significant behavioural or architectural changes should include documentation updates where appropriate.

Relevant documentation may include:

- `README.md`
- `RELEASE_NOTES_R1_1.md`
- `RELEASE_SCOPE.md`
- `ARCHITECTURE.md`
- `OPERATIONS.md`
- `COMMANDS_DRAFT.md`
- `REPO_AUDIT.md`

Operational clarity is considered part of the implementation quality.

---

# What Not To Submit

The following types of changes are unlikely to align with Release 1.1 goals:

- opaque AI automation
- silent auto-apply workflows
- hidden background mutation
- autonomous repository management
- unnecessary architectural complexity
- hype-oriented AI features without operational safeguards

The project intentionally values disciplined engineering workflows over maximal AI autonomy.

---

# Development Status

Neovim-Codex is currently preparing for the Release 1.1 milestone.

Architectural hardening, documentation refinement, and operational improvements are ongoing.

Contributors should expect:

- evolving APIs
- evolving workflows
- ongoing refactors
- expanding operational documentation

---

# Final Notes

Constructive discussion, thoughtful engineering tradeoffs, and operational pragmatism are all strongly encouraged.

The long-term goal of Neovim-Codex is not merely to integrate AI into engineering workflows.

The goal is to explore how AI-assisted engineering systems can remain:

- understandable
- inspectable
- recoverable
- operationally transparent
- human-directed

over a broadening range of supported languages and platforms.