# Neovim-AIDE Documentation

## Purpose

The Neovim-AIDE documentation exists to explain the product, support its users, guide its contributors and capture the engineering knowledge behind the project.

The documentation is treated as part of the product.

It evolves alongside the software and is maintained with the same engineering discipline as the codebase.

---

# Documentation Philosophy

Good documentation should make the project easier to understand, easier to use and easier to contribute to.

The goal is not to document everything.

The goal is to ensure that every important piece of information has a clear, discoverable home.

---

# Documentation Principles

## Single Responsibility

Every document should have one primary responsibility.

If information appears in multiple places, it should be because one document references another—not because the same content has been duplicated.

---

## Progressive Disclosure

Readers should discover information in layers.

```text
What is it?
    │
    ▼
Can I install it?
    │
    ▼
Can I use it?
    │
    ▼
How does it work?
    │
    ▼
How do I contribute?
    │
    ▼
How is it engineered?
```

Each document should assume only the knowledge introduced by the documents before it.

---

## Living Documentation

Documentation is maintained alongside the software.

Engineering changes should include documentation updates whenever behaviour, workflows or interfaces change.

---

## Engineering Artefacts

Documentation is an engineering artefact.

It should be:

- accurate
- version controlled
- reviewable
- maintainable
- testable where appropriate

---

# Documentation Hierarchy

```text
README.md
    Product overview

INSTALL.md
    Installation and first run

docs/README.md
    Documentation index

docs/ARCHITECTURE.md
    System architecture

docs/CONTRIBUTING.md
    Contribution policy

docs/contributor/
    Contributor engineering guides

docs/releases/
    Release engineering
```

---

# Documentation Responsibilities

| Document | Primary Responsibility |
|----------|------------------------|
| `README.md` | Product overview and project entry point |
| `INSTALL.md` | Installation, bootstrap and upgrade |
| `docs/README.md` | Documentation index |
| `docs/ARCHITECTURE.md` | System architecture and design |
| `docs/CONTRIBUTING.md` | Contribution policy |
| `docs/contributor/README.md` | Contributor onboarding |
| `docs/contributor/SANDBOX.md` | Sandbox validation workflow |
| `docs/releases/` | Release planning, notes and checklists |

---

# Navigation Model

Most readers should naturally follow this path.

```text
README
    │
    ▼
INSTALL
    │
    ▼
Documentation Index
    │
    ├── Architecture
    ├── Contributor Guide
    └── Release Documentation
```

Contributors typically continue with:

```text
Contributor Guide
        │
        ▼
Sandbox Guide
        │
        ▼
Release Checklist
```

---

# Future Growth

As Neovim-AIDE evolves, additional documentation should extend the existing structure rather than duplicate it.

New documents should have a clearly defined responsibility and integrate naturally into the documentation hierarchy.

---

# Definition of Done

The documentation architecture is considered healthy when:

- every document has a clearly defined purpose
- responsibilities do not overlap
- duplication is minimised
- navigation between documents is intuitive
- documentation evolves alongside the software