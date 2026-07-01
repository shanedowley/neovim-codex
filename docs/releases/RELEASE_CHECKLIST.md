# Neovim-AIDE Release Checklist

This checklist defines the minimum engineering standard required before any public release of Neovim-AIDE.

The objective is simple:

> Every release should be reproducible, observable and confidence-inspiring.

The checklist exists to ensure that every release is held to the same engineering standard, regardless of who performs the release.

---

# Release Philosophy

Neovim-AIDE is built around three core principles:

- **Correctness**
- **Control**
- **Traceability**

The release process must demonstrate these principles just as clearly as the software itself.

Releases are not considered complete because new functionality has been implemented.

Releases are complete when that functionality has been validated.

---

# Repository

Verify repository health.

- [ ] Working tree clean
- [ ] All intended changes committed
- [ ] No temporary debugging code
- [ ] No commented-out experimental code
- [ ] No accidental dependency updates
- [ ] Commit history reviewed
- [ ] Release branch up to date

---

# Documentation

Verify documentation is complete and consistent.

- [ ] README reviewed
- [ ] INSTALL reviewed
- [ ] Documentation index reviewed
- [ ] Contributor documentation reviewed
- [ ] Sandbox documentation reviewed
- [ ] Release notes updated
- [ ] Product identity consistent
- [ ] Terminology consistent

---

# Bootstrap Validation

Verify installation tooling.

- [ ] `./scripts/bootstrap.sh --check`
- [ ] `./scripts/bootstrap.sh --sync`
- [ ] Health report completes successfully
- [ ] Bootstrap output reviewed
- [ ] Bootstrap failure paths reviewed

---

# Sandbox Validation

Validate the release inside a clean isolated environment.

- [ ] `tools/sandbox.sh down`
- [ ] `tools/sandbox.sh up`
- [ ] `tools/sandbox.sh status`
- [ ] `tools/sandbox.sh reset`

Verify:

- [ ] Fresh installation succeeds
- [ ] Plugins install correctly
- [ ] Neovim launches successfully

---

# Runtime Validation

Inside the sandbox:

- [ ] `:CodexHealth`
- [ ] `:CodexState`
- [ ] Statusline behaviour verified
- [ ] Health cache behaviour verified

---

# Core Workflow Validation

Validate representative AI-assissted development workflows.

- [ ] Explain
- [ ] Refactor
- [ ] Safe Preview
- [ ] Apply
- [ ] Failure Recovery
- [ ] Latency reporting
- [ ] Guardrails
- [ ] Context injection
- [ ] Repeat Last Operation

---

# Regression Validation

Confirm that recently completed stories continue to behave correctly.

- [ ] Bootstrap
- [ ] Sandbox
- [ ] Health model
- [ ] Workflow state
- [ ] Documentation
- [ ] Recovery reports

---

# Product Review

Review the release from the perspective of a first-time user.

Ask:

- Would I understand what this product is?
- Would installation be straightforward?
- Would I trust this system?
- Would I understand failures?
- Would I understand recovery?
- Would I recommend this release to another engineer?

---

# Release

Before publishing:

- [ ] Version number updated
- [ ] Release notes complete
- [ ] Git tag created
- [ ] Final review completed
- [ ] GitHub Release drafted
- [ ] Release published

---

# Definition of Done

A Neovim-AIDE release is complete when:

- the software behaves correctly;
- the engineering workflow has been validated;
- the documentation is accurate;
- the release is reproducible;
- contributors can reproduce the same outcome;
- engineers can trust the result.

Shipping software is not the goal.
Shipping trustworthy IDE software is.

