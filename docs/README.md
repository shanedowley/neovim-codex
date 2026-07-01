# Neovim-AIDE Documentation

Welcome to the documentation for **Neovim-AIDE**.

Neovim-AIDE is an **AI-Assisted IDE based on Neovim**.

This documentation is organised to help you quickly find the information you need, whether you are using Neovim-AIDE in your daily software engineering workflow or contributing to its development.

---

# Getting Started

### I want to use Neovim-AIDE

Begin with the project README.

From there you can install Neovim-AIDE, complete the bootstrap process and start using the available AI-assisted workflows.

---

### I want to contribute to Neovim-AIDE

Begin with:

```text
CONTRIBUTING.md
```

The contributor guide explains the project's engineering philosophy, development workflow and contribution expectations.

---

# Documentation Map

The documentation is organised into a small number of focused guides.

Each document has a single primary responsibility.

| Document          | Purpose                                                                                                        |
| ----------------- | -------------------------------------------------------------------------------------------------------------- |
| `ARCHITECTURE.md` | Explains how Neovim-AIDE is designed and how its major runtime subsystems work together.                       |
| `CONTRIBUTING.md` | Explains how contributors are expected to develop, validate and submit changes.                                |
| `contributor/`    | Additional contributor documentation covering engineering workflows, validation and project-specific guidance. |
| `releases/`       | Historical release notes and release documentation.                                                            |

---

# Documentation Structure

```text
docs/
│
├── ARCHITECTURE.md
├── CONTRIBUTING.md
├── README.md
│
├── contributor/
│
└── releases/
```

The documentation is intentionally organised so that each guide answers a different question.

- **README** — Where do I start?
- **Architecture** — How is Neovim-AIDE put together?
- **Contributing** — How do I contribute?
- **Contributor Guides** — How does the project work in practice?
- **Release Documentation** — What changed in each release?

This separation keeps individual documents concise while reducing duplication across the documentation set.

---

# Documentation Principles

The documentation follows the same engineering principles as the software itself.

Documentation should be:

- technically accurate
- practical
- concise
- easy to navigate
- easy to maintain

Each document should have a clearly defined purpose and avoid duplicating information maintained elsewhere.

---

# Keeping Documentation Current

Documentation is considered part of the product.

Behavioural, architectural or workflow changes should be accompanied by corresponding documentation updates where appropriate.

The objective is for the documentation to remain aligned with the shipped product rather than describing historical behaviour or future intentions.

---

# Need Help?

If you cannot find the information you are looking for:

- review the project README
- consult the relevant guide listed above
- open a discussion or issue on GitHub if you believe documentation is missing or unclear

Improving documentation is always a welcome contribution.

