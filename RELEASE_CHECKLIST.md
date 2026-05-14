# Neovim-Codex RC1.0 — Release Checklist

Status Legend:

- [ ] Not started
- [~] In progress
- [x] Complete

---

# 1. Repository Hygiene

- [x] Remove runtime/cache artefacts
- [x] Remove machine-specific paths
- [x] Remove personal workflow leakage
- [x] Validate `.gitignore`
- [x] Audit tracked repository surface
- [x] Remove duplicate architecture documentation

---

# 2. Documentation

- [x] README.md
- [x] INSTALL.md
- [x] ARCHITECTURE.md
- [x] CONTRIBUTING.md
- [x] LICENSE
- [x] Demo workflow documentation
- [ ] Replace `<your-repo-url>` placeholders
- [ ] Final documentation proofreading pass

---

# 3. Bootstrap & Operational Validation

- [x] Repo-local bootstrap script
- [x] `--check` validation
- [x] `--sync` validation
- [x] `--test-health-gate` validation
- [x] Runtime/config separation validation
- [x] Fresh clone validation
- [x] Public surface leakage audit

---

# 4. Demo Assets

- [x] D1 Safe Refactor
- [x] D2 Failure Recovery
- [x] D3 Operational Diagnostics
- [x] D4 Legacy Explainability
- [x] D5 Human-in-the-Loop Engineering
- [ ] Verify all README links
- [ ] Verify all asset paths

---

# 5. Release Engineering

- [ ] Final repository structure audit
- [ ] Final grep audit
- [ ] Final bootstrap pass
- [ ] GitHub repository creation
- [ ] Push canonical repository
- [ ] Create RC1.0 tag
- [ ] Publish release notes

---

# 6. Post-RC Backlog

Future release candidates may include:

- Linux hardening
- Windows / WSL support
- CI validation pipelines
- Packaging improvements
- Standalone plugin extraction
- Multi-language expansion
- OpenRouter abstraction
- Telemetry standardisation
- Advanced recovery tooling
