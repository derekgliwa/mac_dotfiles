#!/usr/bin/env zsh
# Tags git-ai checkpoints with runtime + backend so `git-ai stats --json`
# can slice attribution across local vs cloud work. Numbered 45 so it
# loads before 60.mise.zsh — git-ai itself doesn't need mise, but tools
# it attributes to might.
# See: https://github.com/git-ai-project/git-ai

# Prepend ~/.git-ai/bin so the `git` symlink there intercepts plain
# `git` invocations and routes them through git-ai. `git-og` (also in
# that dir) preserves direct access to the real git binary.
case ":$PATH:" in
  *":$HOME/.git-ai/bin:"*) ;;
  *) PATH="$HOME/.git-ai/bin:$PATH" ;;
esac

if command -v git-ai >/dev/null; then
  export GIT_AI_CUSTOM_ATTRIBUTES='{"runtime":"local","backend":"ollama"}'
fi
