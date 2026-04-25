#!/usr/bin/env zsh
command -v eza >/dev/null && alias ls='eza --icons --git'
command -v bat >/dev/null && alias cat='bat --paging=never'
command -v fd  >/dev/null && alias find='fd'
alias g='git'
alias gs='git status'
