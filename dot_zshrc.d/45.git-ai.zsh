#!/usr/bin/env zsh
# Tags git-ai checkpoints with runtime + backend so `git-ai stats --json`
# can slice attribution across local vs cloud work. Numbered 45 so it
# loads before 60.mise.zsh — git-ai itself doesn't need mise, but tools
# it attributes to might.
# See: https://github.com/git-ai-project/git-ai

if command -v git-ai >/dev/null; then
  export GIT_AI_CUSTOM_ATTRIBUTES='{"runtime":"local","backend":"ollama"}'
fi
