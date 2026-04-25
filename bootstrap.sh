#!/usr/bin/env bash
# Usage: curl -fsSL https://raw.githubusercontent.com/<you>/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

# 1. Homebrew (macOS + Linux)
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 2. Minimum viable tools to run chezmoi
brew install chezmoi mise

# 3. Pull + apply dotfiles. Replace <you> with your GitHub username.
chezmoi init --apply <you>

echo "Done. Open a new shell to pick up mise + zsh modules."
