# Personal dotfiles scaffold

A starter chezmoi + mise + Homebrew setup. Replace `<you>` in `bootstrap.sh` with your GitHub username, push this repo, then on a new machine run:

```bash
curl -fsSL https://raw.githubusercontent.com/<you>/mac_dotfiles/main/bootstrap.sh | bash
```

## Layout

- `.chezmoi.yml.tmpl` — init prompts; answers stored in `~/.config/chezmoi/chezmoi.yml`
- `.chezmoidata/packages.yml` — single source of truth for brew packages
- `.chezmoiscripts/run_onchange_before_install-packages.sh.tmpl` — reinstalls brews when `packages.yml` changes
- `.chezmoiignore` — files that stay in the repo but are not copied to `$HOME`
- `dot_zshrc` + `dot_zshrc.d/` — modular zsh config (numbered load order)
- `dot_config/mise/config.toml` — user-wide mise tools
- `dot_gitconfig.tmpl` — templated from init answers
- `dot_gitignore_global` — global gitignore

## Escape hatches

- `~/.gitconfig.local` — last-include-wins overrides for git
- `~/.zshrc.d/99.local.zsh` — unmanaged drop-in for machine-specific aliases
- `~/.config/mise/conf.d/*.toml` — personal mise overrides
