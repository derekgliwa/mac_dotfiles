#!/usr/bin/env zsh
# Tab completion: initialize zsh's completion engine, then load per-tool
# completions for the CLIs this setup installs.

setopt COMPLETE_IN_WORD       # complete from the cursor, not just end of word

# Homebrew adds its completions dir to FPATH via `brew shellenv` (run in
# dot_zshrc), so initialize the engine here, after FPATH is populated.
# -u uses Homebrew's completion dirs without the insecure-directory prompt
# they trip on some setups.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
autoload -Uz compinit
compinit -u

# Case-insensitive matching plus an arrow-key navigable menu.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

command -v chezmoi  >/dev/null && source <(chezmoi completion zsh)
command -v gt       >/dev/null && source <(SHELL=zsh gt completion)
command -v starship >/dev/null && source <(starship completions zsh)

# MISE_PREFER_OFFLINE avoids blocking shell startup on mise's network fetches:
# `mise completion` builds the full toolset, which otherwise hits GitHub /
# mise-versions release metadata — flaky wifi can hang a new terminal for a
# minute+. https://github.com/jdx/mise/blob/main/src/cli/completion.rs
command -v mise >/dev/null && source <(MISE_PREFER_OFFLINE=1 mise completion zsh)
