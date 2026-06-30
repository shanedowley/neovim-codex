# Neovim-AIDE Commands

This document provides a quick reference to the user-facing commands available in Neovim-AIDE.

For installation, see `INSTALL.md`.

For architecture and runtime behaviour, see `docs/ARCHITECTURE.md`.

## Core Workflow

| Command               | Purpose                                     |
| --------------------- | ------------------------------------------- |
| `:CodexMode`          | Set the current Codex mode.                 |
| `:CodexModeCycle`     | Cycle through available Codex modes.        |
| `:CodexModeList`      | List available Codex modes.                 |
| `:CodexContext`       | Show current project context block.         |
| `:CodexToggleContext` | Toggle project context injection.           |
| `:CodexCommands`      | Open the in-Neovim Codex command reference. |

---

## Session Memory

| Command             | Purpose                                     |
| ------------------- | ------------------------------------------- |
| `:CodexLastOp`      | Show the last remembered Codex operation.   |
| `:CodexLastOpClear` | Clear the remembered last Codex operation.  |
| `:CodexRepeat`      | Repeat the last remembered Codex operation. |

---

## Health and Diagnostics

| Command               | Purpose                                         |
| --------------------- | ----------------------------------------------- |
| `:CodexHealth`        | Open full Codex diagnostic health report.       |
| `:CodexHealthCheck`   | Show quick PASS/FAIL health status.             |
| `:CodexState`         | Show current workflow state.                    |
| `:CodexStateHistory`  | Show recent workflow state transitions.         |
| `:CodexGuardrails`    | Show active Codex safety guardrails.            |
| `:CodexLatency`       | Show latency summary and recent latency events. |
| `:CodexLog`           | Open the Codex operational log.                 |
| `:CodexPromptVersion` | Show active Codex prompt version information.   |

---

## Recovery

| Command                | Purpose                                                  |
| ---------------------- | -------------------------------------------------------- |
| `:CodexRecovery`       | Show the last captured failure report.                   |
| `:CodexRecoveryClear`  | Clear the last captured failure report.                  |
| `:CodexExplainFailure` | Ask Codex to explain the last safe, explainable failure. |

---

## Notification

| Command                             | Purpose                                                                           |
| ----------------------------------- | --------------------------------------------------------------------------------- |
| `:CodexNotifyPlacement {placement}` | Configure notification placement (`top_right`, `top_center`, `bottom_left`, etc). |
| `:CodexNotifyTest`                  | Test Codex notification rendering.                                                |

### Notification placement examples

:CodexNotifyPlacement top_right
:CodexNotifyPlacement top_center
:CodexNotifyPlacement bottom_left
