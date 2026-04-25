#!/usr/bin/env zsh
# One-line nag at shell startup if the machine has drift (chezmoi/mise).
# Runs late so `dg` is on PATH (set in dot_zshrc) and quiet on success.

command -v dg >/dev/null && dg machine status --quiet 2>/dev/null
