# REPO_AUDIT.md

## Repository Audit — Release 1.1

---

# Purpose

This document captures repository hygiene observations, architectural boundary decisions, and operational audit checks performed during preparation for the Neovim-Codex Release 1.1 public release.

The goal is to ensure the repository is:

- operationally credible
- portable
- inspectable
- reproducible
- safe for public release

---

# Core Repository Scope

## Keep

Core Neovim-Codex project files:

- `codex/docs/`
- `codex/prompts/`
- `lua/codex/`
- `lua/codex_cli.lua`
- `lua/codex_guard.lua`
- `lua/codex_log.lua`
- `lua/codex_memory.lua`
- `lua/codex_mode.lua`
- `lua/codex_parse.lua`
- `lua/codex_prompt.lua`
- `lua/codex_recovery.lua`
- `lua/codex_setup.lua`
- `lua/ui_notify.lua`

Supporting Neovim environment:

- `init.lua`
- `lazy-lock.json`
- `lua/plugins/`
- `lua/keymaps/`

---

# Repository Strategy Decision

## Release 1.1 Repository Decision

Release 1.1 ships as:

> a full dotfiles-style Neovim engineering environment centred around the Neovim-Codex AI-Assisted Engineering System.

The repository intentionally includes:

- the Neovim-Codex subsystem
- supporting IDE tooling
- keymaps
- plugins
- debugging workflows
- operational tooling
- broader editor ergonomics

The repository is intentionally broader than a minimal isolated plugin.

Architectural boundaries are documented in:

- `codex/docs/ARCHITECTURE.md`

---

# Scope Clarification

The following areas are considered supporting IDE infrastructure rather than core Neovim-Codex runtime:

- `after/syntax/asm.vim`
- `lua/plugins/vimtex.lua`
- `lua/plugins/web.lua`
- `lua/snippets/`
- `lua/themes/`
- `lua/theme_controller.lua`
- `lua/theme_cycle.lua`
- `lua/diag/`

These remain intentionally included in Release 1.1 as part of the complete engineering environment.

---

# Completed Audit Actions

## Repository Artefact Audit

Status: PASS

Removed tracked non-release artefacts:

- `lua/_scratch/neotest_probe.lua`
- `lua/plugins/notify.lua.org`

Verified:

- no scratch artefacts tracked
- no backup artefacts tracked

---

## Hardcoded Path Audit

Status: PASS

Removed hardcoded user-specific filesystem paths.

Replaced with portable path expansion:

```lua
vim.env.NVIM_CODEX_PROJECT_ROOT
```

Verified:

- no remaining hardcoded `/Users/`
- no hardcoded Homebrew paths
- no hardcoded Desktop paths

---

## Secret / Credential Audit

Status: PASS

No:

- API keys
- passwords
- bearer tokens
- embedded credentials
- authentication secrets

found in tracked repository files.

Only benign parser reference found:

- `codex_parse.lua`
  - `"tokens used"`

---

## Runtime Hygiene Audit

Status: PASS

Verified exclusions for:

- runtime state
- Neovim cache
- swap files
- backup files
- logs
- local runtime artefacts

Repository currently uses:

- bare dotfiles repository strategy
- `$HOME/.gitignore`

for runtime hygiene enforcement.

---

# Current Assessment

Release 1.1 repository state is currently considered:

- operationally clean
- structurally coherent
- portable
- publicly publishable
- free from known credential leakage
- free from known runtime artefact pollution

Additional OSS hardening work remains planned around:

- licensing
- contribution workflow
- CI validation
- issue templates
- release automation
- semantic versioning

However current repository hygiene is considered suitable for Release 1.1 public release.
