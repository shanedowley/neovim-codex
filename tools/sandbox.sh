#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

SANDBOX_ROOT=/tmp/neovim-codex-sandbox

CONFIG_DIR="$SANDBOX_ROOT/config"
DATA_DIR="$SANDBOX_ROOT/data"
STATE_DIR="$SANDBOX_ROOT/state"
CACHE_DIR="$SANDBOX_ROOT/cache"
SANDBOX_REPO="$CONFIG_DIR/nvim"

create_sandbox() {
    echo "Creating sandbox..."
    echo

    mkdir -p \
        "$CONFIG_DIR" \
        "$DATA_DIR" \
        "$STATE_DIR" \
        "$CACHE_DIR"

    if [ -d "$SANDBOX_REPO" ]; then
        echo "Repository:"
        echo "  Reusing existing clone."
        return
    fi

    echo "Cloning repository..."

    if git clone "$REPO_ROOT" "$SANDBOX_REPO"; then
        echo
        echo "Repository cloned to:"
        echo "  $SANDBOX_REPO"
    else
        echo
        echo "ERROR: Failed to clone repository."
        exit 1
    fi
}

reset_sandbox() {
    if [ ! -d "$SANDBOX_REPO" ]; then
        echo "ERROR: Sandbox repository not found."
        echo
        echo "Run first:"
        echo "  tools/sandbox.sh up"
        exit 1
    fi

    echo "Resetting sandbox..."
    echo

    rm -rf \
        "$DATA_DIR" \
        "$STATE_DIR" \
        "$CACHE_DIR"

    mkdir -p \
        "$DATA_DIR" \
        "$STATE_DIR" \
        "$CACHE_DIR"

    echo "✓ Sandbox reset complete."
}

remove_sandbox() {
    if [ ! -d "$SANDBOX_ROOT" ]; then
        echo "Sandbox not present."
        echo "Nothing to do."
        return
    fi

    echo "Removing sandbox..."
    echo

    rm -rf "$SANDBOX_ROOT"

    echo "✓ Sandbox removed."
}

print_dir_status() {
    label="$1"
    path="$2"

    if [ -d "$path" ]; then
        echo "  ✓ $label"
    else
        echo "  ✗ $label"
    fi
}

status_sandbox() {
    echo "Neovim-Codex Sandbox Status"
    echo "==========================="
    echo

    echo "Sandbox:"
    if [ -d "$SANDBOX_REPO" ]; then
        echo "  ✓ Present"
    else
        echo "  ✗ Not found"
        return
    fi

    echo
    echo "Source repository:"
    echo "  $REPO_ROOT"

    echo
    echo "Sandbox repository:"
    echo "  $SANDBOX_REPO"

    echo
    echo "HEAD:"
    if git -C "$SANDBOX_REPO" rev-parse --short HEAD >/dev/null 2>&1; then
        echo "  $(git -C "$SANDBOX_REPO" rev-parse --short HEAD)"
    else
        echo "  -"
    fi

    echo
    echo "Directories:"
    print_dir_status "config" "$CONFIG_DIR"
    print_dir_status "data" "$DATA_DIR"
    print_dir_status "state" "$STATE_DIR"
    print_dir_status "cache" "$CACHE_DIR"
}

print_next_steps() {
    echo
    echo "✓ Sandbox ready."
    echo
    echo "Location:"
    echo "  $SANDBOX_ROOT"
    echo
    echo "Source repository:"
    echo "  $REPO_ROOT"
    echo
    echo "Enter sandbox environment:"
    echo "  export XDG_CONFIG_HOME=$CONFIG_DIR"
    echo "  export XDG_DATA_HOME=$DATA_DIR"
    echo "  export XDG_STATE_HOME=$STATE_DIR"
    echo "  export XDG_CACHE_HOME=$CACHE_DIR"
    echo "  cd $SANDBOX_REPO"
    echo
    echo "Launch:"
    echo "  nvim"
}

print_help() {
    cat <<EOF
Neovim-Codex Sandbox

Usage:

    sandbox.sh up
    sandbox.sh reset
    sandbox.sh status
    sandbox.sh down

Repository:

    $REPO_ROOT

EOF
}

case "${1:-help}" in

    up)
        create_sandbox
        print_next_steps
        ;;

    reset)
        reset_sandbox
        print_next_steps
        ;;

    status)
        status_sandbox
        ;;

    down)
        remove_sandbox
        ;;

    help|*)
        print_help
        ;;
esac