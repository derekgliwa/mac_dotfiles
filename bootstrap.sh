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

# 3. Interactive repo selection (with fallback to env var)
REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  # Try to read interactively if stdin is available
  if [[ -t 0 ]]; then
    read -p "Enter your dotfiles repo URL (or GitHub username): " REPO
  else
    echo "Error: No repo provided and stdin is not interactive."
    echo "Usage: curl -fsSL https://raw.githubusercontent.com/<you>/mac_dotfiles/main/bootstrap.sh | bash -s -- <repo>"
    exit 1
  fi
fi

# 4. Apply
chezmoi init --apply "$REPO"

echo "Done. Open a new shell to pick up mise + zsh modules."
