# Neovim-AIDE Development Sandbox

## Purpose

Reliable software development depends on separating development from release validation.

The Neovim-AIDE Development Sandbox provides a clean, isolated Neovim environment for installation testing, regression testing, release validation and contributor onboarding.

By validating changes inside an isolated environment, Neovim-AIDE can be tested exactly as a new user would experience it, without relying on a contributor's personal Neovim configuration.

This approach eliminates an entire class of environment-specific issues and establishes a consistent, reproducible validation workflow for both project maintainers and contributors.

---

# Engineering Principle

## Sandbox-First Validation

> **All new functionality should be validated in the isolated sandbox before it is considered complete or ready for release.**

A contributor's personal Neovim configuration is a **development environment**.

The sandbox is the **release validation environment**.

Sandbox-first validation provides every contributor with a consistent, reproducible engineering environment regardless of their personal Neovim configuration.

Every release candidate should be validated from a clean sandbox installation before public release.

---

# Sandbox Layout

The sandbox is created under:

```text
/tmp/neovim-codex-sandbox
```

> **Note:** If the sandbox location changes in the future, this document should be updated to match the implementation.

The sandbox uses dedicated XDG directories:

```text
config/
data/
state/
cache/
```

The Neovim-AIDE repository is cloned into:

```text
config/nvim
```

This creates a fully isolated Neovim installation.

No files are read from or written to the contributor's personal Neovim environment:

```text
~/.config/nvim
~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim
```

This guarantees that validation is completely independent of an existing development setup.

---

# Sandbox Lifecycle

The sandbox is intentionally managed through a small set of explicit lifecycle operations.

## Create

```bash
tools/sandbox.sh up
```

Creates the isolated sandbox directory structure, clones the current repository and displays the environment required to enter the sandbox.

---

## Status

```bash
tools/sandbox.sh status
```

Displays the current sandbox status, including:

- sandbox presence
- source repository
- sandbox repository
- repository revision
- XDG directory status

This command provides a quick health check of the sandbox environment.

---

## Reset

```bash
tools/sandbox.sh reset
```

Deletes the isolated runtime directories while preserving the cloned repository.

The following directories are recreated:

- data
- state
- cache

The repository itself is intentionally preserved.

This provides a clean runtime environment for repeated installation and regression testing.

---

## Destroy

```bash
tools/sandbox.sh down
```

Removes the sandbox completely.

The next validation cycle should begin with a fresh `tools/sandbox.sh up`.

---

# Engineering Workflow

Every contribution should follow the same repeatable engineering workflow.

```text
Observe
    ↓
Analyse
    ↓
Design
    ↓
Implement
    ↓
Local Validation
    ↓
Sandbox Validation
    ↓
Review
    ↓
Release
```

Applying the same workflow consistently improves release quality, simplifies debugging and reduces environment-specific defects.

---

# When to Use the Sandbox

The sandbox should be used whenever you need confidence that Neovim-AIDE behaves correctly in a clean environment.

Typical situations include:

- validating new functionality
- reproducing reported defects
- testing installation changes
- testing bootstrap changes
- validating documentation that affects installation or setup
- preparing a release candidate
- verifying a fresh installation experience

When in doubt, validate in the sandbox.

---

# Entering the Sandbox

After creating the sandbox, the required XDG environment variables are displayed.

Example:

```bash
export XDG_CONFIG_HOME=/tmp/neovim-codex-sandbox/config
export XDG_DATA_HOME=/tmp/neovim-codex-sandbox/data
export XDG_STATE_HOME=/tmp/neovim-codex-sandbox/state
export XDG_CACHE_HOME=/tmp/neovim-codex-sandbox/cache

cd /tmp/neovim-codex-sandbox/config/nvim

nvim
```

Verify that Neovim is using the sandbox configuration:

```vim
:lua print(vim.fn.stdpath("config"))
```

Expected output:

```text
/tmp/neovim-codex-sandbox/config/nvim
```

---

# Typical Validation Session

A typical validation session looks like:

```bash
tools/sandbox.sh up

export XDG_CONFIG_HOME=/tmp/neovim-codex-sandbox/config
export XDG_DATA_HOME=/tmp/neovim-codex-sandbox/data
export XDG_STATE_HOME=/tmp/neovim-codex-sandbox/state
export XDG_CACHE_HOME=/tmp/neovim-codex-sandbox/cache

cd /tmp/neovim-codex-sandbox/config/nvim

nvim
```

Inside Neovim:

```vim
:CodexHealth
:CodexState
```

Perform feature validation, regression testing and installation verification.

When another clean validation cycle is required:

```bash
tools/sandbox.sh reset
```

When testing has completed:

```bash
tools/sandbox.sh down
```

---

# Resetting the Sandbox

Reset the sandbox whenever:

- validating a new feature
- reproducing a reported defect
- testing installation changes
- testing bootstrap changes
- beginning release validation
- repeating an installation test

Resetting ensures that every validation cycle begins from a clean runtime environment.

---

# Engineering Philosophy

The development sandbox reflects the same engineering principles used throughout Neovim-AIDE.

- explicit operations
- deterministic behaviour
- isolated execution
- observable state
- reproducible validation
- human-controlled workflows

The objective is not simply to make testing easier.

The objective is to make every release trustworthy.

---

# Summary

The Neovim-AIDE Development Sandbox is the project's standard environment for release validation.

By separating development from release validation, contributors can test Neovim-AIDE in a clean, reproducible environment that accurately represents a first-time installation.

Every validated release increases confidence that Neovim-AIDE will behave consistently across contributor machines and end-user installations alike.

Sandbox-First Validation is therefore not simply a testing technique—it is one of the core engineering principles of the Neovim-AIDE project.

