#!/usr/bin/env zsh
# mise hooks into chpwd so project mise.toml auto-activates.
command -v mise >/dev/null && eval "$(mise activate zsh)"
