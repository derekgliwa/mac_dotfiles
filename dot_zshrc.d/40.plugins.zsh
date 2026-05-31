#!/usr/bin/env zsh
# Inline autosuggestions + syntax highlighting via the antidote plugin manager.
# Plugin list lives in ~/.zsh_plugins.txt. Loads after 20.completions so
# compinit has already run.

bindkey -e   # emacs keybindings (Ctrl-E / End accepts the autosuggestion)

if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/antidote/share/antidote" ]]; then
  source "$HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh"
  antidote load
fi

bindkey '^ ' autosuggest-accept   # Ctrl-Space also accepts the suggestion
