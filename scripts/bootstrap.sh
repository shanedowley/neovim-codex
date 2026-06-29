#!/usr/bin/env bash

set -euo pipefail

MODE="${1:---check}"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

NVIM_CONFIG_DIR="$XDG_CONFIG_HOME/nvim"
NVIM_DATA_DIR="$XDG_DATA_HOME/nvim"
NVIM_STATE_DIR="$XDG_STATE_HOME/nvim"
NVIM_CACHE_DIR="$XDG_CACHE_HOME/nvim"

echo "=== Neovim-Codex R1.2 Bootstrap ==="
echo "Software Engineering Environment Check"
echo

echo "This script validates:"
echo "  - platform support"
echo "  - required dependencies"
echo "  - Neovim config presence"
echo "  - runtime/config separation"
echo "  - lazy.nvim bootstrap"
echo "  - Codex operational health"
echo

fail() {
  echo "❌ $1"
  exit 1
}

warn() {
  echo "⚠️  $1"
}

ok() {
  echo "✅ $1"
}

summary() {
  echo
  echo "────────────────────────────────────────────"
  echo "Neovim-Codex Bootstrap Summary"
  echo "────────────────────────────────────────────"
  echo "Mode: $MODE"
  echo "Config: $NVIM_CONFIG_DIR"
  echo "Data:   $NVIM_DATA_DIR"
  echo "State:  $NVIM_STATE_DIR"
  echo
  ok "Environment validation completed"
}


usage() {
  cat <<'EOF'
Usage:
  ./scripts/bootstrap.sh --check
      Fast validation + healthcheck report

  ./scripts/bootstrap.sh --sync
      Full plugin sync + validation + healthcheck report

  ./scripts/bootstrap.sh --test-health-gate
      Verify runner blocks when health is not PASS
EOF
}

require_command() {
  local cmd="$1"
  local message="$2"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "$message"
  fi
}

require_file() {
  local file="$1"
  local message="$2"

  if [ ! -f "$file" ]; then
    fail "$message"
  fi
}

test_health_gate() {
  echo "Testing health gate enforcement..."
  echo

  local log_file="$NVIM_STATE_DIR/codex.log"

  local before_count
  before_count=$(
    grep "op=health_gate_test" "$log_file" 2>/dev/null \
      | grep "reason=healthcheck_not_pass" \
      | grep -c "stage=preflight" \
      || true
  )

  if ! nvim --headless \
    "+lua require('codex.runner').run({ prompt = 'test', op = 'health_gate_test', _force_health_fail_for_test = true })" \
    "+qa"; then
    warn "Neovim exited non-zero during health gate test; checking log anyway..."
  fi

  local after_count
  after_count=$(
    grep "op=health_gate_test" "$log_file" 2>/dev/null \
      | grep "reason=healthcheck_not_pass" \
      | grep -c "stage=preflight" \
      || true
  )

  if [ "$after_count" -gt "$before_count" ]; then
    ok "Health gate enforcement: PASS"
  else
    fail "Health gate enforcement: FAIL — expected log event not found in $log_file"
  fi
}




case "$MODE" in
  --check|--sync|--test-health-gate)
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage
    fail "Unknown mode: $MODE"
    ;;
esac

OS="$(uname -s)"

echo "[1/8] Detecting platform..."
echo

case "$OS" in
  Darwin)
    ok "macOS detected"
    ;;
  Linux)
    ok "Linux detected"
    warn "Linux support is currently experimental for R1.2"
    ;;
  *)
    fail "Unsupported OS: $OS"
    ;;
esac

echo
echo "[2/8] Checking required dependencies..."
echo

require_command "nvim" "nvim not found. Install Neovim 0.11+ first."
require_command "git" "git not found. Install Git first."
require_command "clang" "clang not found. On macOS run: xcode-select --install. On Linux install clang via your package manager."
require_command "diff" "diff not found. Install a POSIX-compatible diff utility."

NVIM_VERSION="$(nvim --version | head -n1)"

ok "Required dependencies found"
ok "$NVIM_VERSION"

echo
echo "[3/8] Checking optional dependencies..."
echo

if command -v codex >/dev/null 2>&1; then
  ok "codex CLI found: $(codex --version 2>/dev/null || echo unknown)"
else
  warn "codex CLI not found. AI-assisted workflows will be unavailable."
fi

if command -v node >/dev/null 2>&1; then
  ok "node found: $(node --version)"
else
  warn "node not found. JavaScript debugging workflows may be degraded."
fi

if command -v npm >/dev/null 2>&1; then
  ok "npm found: $(npm --version)"
else
  warn "npm not found. vscode-js-debug workflows may be degraded."
fi

echo
echo "[4/8] Ensuring XDG directories..."
echo

mkdir -p "$NVIM_DATA_DIR"
mkdir -p "$NVIM_STATE_DIR"
mkdir -p "$NVIM_CACHE_DIR"

ok "XDG runtime directories present"
ok "Config directory expected at: $NVIM_CONFIG_DIR"

echo
echo "[5/8] Checking Neovim-Codex config presence..."
echo

require_file "$NVIM_CONFIG_DIR/init.lua" \
  "Missing $NVIM_CONFIG_DIR/init.lua. Install or symlink this repo as your Neovim config first."

require_file "$NVIM_CONFIG_DIR/lua/codex/config.lua" \
  "Missing Codex config module: $NVIM_CONFIG_DIR/lua/codex/config.lua"

require_file "$NVIM_CONFIG_DIR/lua/codex/runner.lua" \
  "Missing Codex runner module: $NVIM_CONFIG_DIR/lua/codex/runner.lua"

require_file "$NVIM_CONFIG_DIR/lua/codex/health.lua" \
  "Missing Codex health module: $NVIM_CONFIG_DIR/lua/codex/health.lua"

ok "Neovim-Codex config files found"

echo
echo "[6/8] Checking config/runtime separation..."
echo

for bad in \
  "$NVIM_CONFIG_DIR/lazy" \
  "$NVIM_CONFIG_DIR/nvim" \
  "$NVIM_CONFIG_DIR/tmp" \
  "$NVIM_CONFIG_DIR/gem"
do
  if [ -e "$bad" ]; then
    fail "Runtime artefact found in config directory: $bad"
  fi
done

ok "Config directory is clean"

echo
echo "[7/8] Bootstrapping lazy.nvim..."
echo

LAZY_PATH="$NVIM_DATA_DIR/lazy/lazy.nvim"

if [ ! -d "$LAZY_PATH" ]; then
  git clone \
    --filter=blob:none \
    https://github.com/folke/lazy.nvim.git \
    --branch=stable \
    "$LAZY_PATH"

  ok "lazy.nvim installed"
else
  ok "lazy.nvim already present"
fi

echo
echo "[8/8] Running mode: $MODE"
echo

case "$MODE" in
  --sync)
    echo "Syncing plugins..."
    nvim --headless "+Lazy! sync" +qa

    echo
    echo "Running Codex healthcheck report..."
    nvim --headless "+checkhealth codex" +qa

    echo
    ok "Bootstrap complete (--sync)"
    ;;

  --check)
    echo "Skipping plugin sync. Use --sync for full rebuild/update."

    echo
    echo "Running Codex healthcheck report..."
    nvim --headless "+checkhealth codex" +qa

    echo
    ok "Bootstrap complete (--check)"
    ;;

  --test-health-gate)
    test_health_gate

    echo
    ok "Bootstrap complete (--test-health-gate)"
    ;;
esac

summary

echo
echo "Next steps:"
echo "  1. Launch Neovim"
echo "  2. Run :CodexHealth"
echo "  3. Open a C/C++ source file"
echo "  4. Visually select some code"
echo "  5. Press <leader>cE"
echo
echo "Neovim-Codex R1.2 bootstrap finished."

