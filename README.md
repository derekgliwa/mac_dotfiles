# Personal dotfiles scaffold

A starter chezmoi + mise + Homebrew setup. Replace `<you>` in `bootstrap.sh` with your GitHub username, push this repo, then on a new machine run:

```bash
curl -fsSL https://raw.githubusercontent.com/<you>/mac_dotfiles/main/bootstrap.sh | bash -s -- https://github.com/<you>/mac_dotfiles
```

## Layout

- `.chezmoi.yml.tmpl` — init prompts; answers stored in `~/.config/chezmoi/chezmoi.yml`
- `.chezmoidata/packages.yml` — single source of truth for brew packages
- `.chezmoiscripts/run_onchange_before_install-packages.sh.tmpl` — reinstalls brews when `packages.yml` changes
- `.chezmoiignore` — files that stay in the repo but are not copied to `$HOME`
- `dot_zshrc` + `dot_zshrc.d/` — modular zsh config (numbered load order)
- `dot_zsh_plugins.txt` — antidote plugin bundle (autosuggestions, syntax highlighting, autopair)
- `dot_config/mise/config.toml` — user-wide mise tools
- `dot_gitconfig.tmpl` — templated from init answers
- `dot_gitignore_global` — global gitignore

### Shell modules (`dot_zshrc.d/`)

Sourced in numeric order by `dot_zshrc`:

| Module | Purpose |
| --- | --- |
| `10.history.zsh` | shared, de-duplicated, timestamped history |
| `20.completions.zsh` | `compinit` + tab completions for chezmoi / gt / starship / mise |
| `40.plugins.zsh` | antidote → inline autosuggestions + syntax highlighting + autopair |
| `45.git-ai.zsh` | routes `git` through git-ai for checkpoint attribution |
| `50.prompt.zsh.tmpl` | starship prompt, atuin history, zoxide (prompt/history gated by init prefs) |
| `60.mise.zsh` | `mise activate` for per-directory tool versions |
| `70.aliases.zsh` | eza / bat / fd aliases + git shortcuts |
| `80.dg-status.zsh` | one-line drift nag at shell startup |

The completion and plugin tooling needs `antidote` (in `packages.yml`); `mise`
completions are fetched with `MISE_PREFER_OFFLINE=1` so a flaky network can't
stall a new shell.

## Syncing changes

`chezmoi init --apply <repo>` clones this repo into the chezmoi **source
directory** (`~/.local/share/chezmoi`) and copies files into `$HOME`. Editing
your shell, mise, or git config is therefore a round-trip: change the source,
apply it locally, then push so other machines can pull it.

### Edit → push (the machine where you make changes)

```bash
chezmoi edit ~/.zshrc        # edit the source copy of a managed file
chezmoi diff                 # preview what `apply` would change in $HOME
dg machine repair            # = chezmoi apply — test the change locally
chezmoi cd                   # drop into the source dir...
git add -A && git commit -m "tweak zsh completions" && git push
exit                         # leave the source dir
```

`dg machine repair` only re-applies committed source to `$HOME` (no network).
Use it after editing the source or when `dg machine status` reports drift.

### Pull → apply (every other machine)

```bash
dg machine update
```

`dg machine update` is the one command to sync pushed changes. It runs:

1. `chezmoi update` — `git pull` in the source dir, then `chezmoi apply`
2. `brew update && brew upgrade`
3. `mise upgrade`

If your push touched `.chezmoidata/packages.yml`, the content hash changes and
`run_onchange_before_install-packages.sh` reruns during apply, so new brews
(e.g. `antidote`) install automatically. Open a fresh shell afterward to pick
up reloaded zsh modules.

### `dg machine` reference

| Command | What it does |
| --- | --- |
| `dg machine status [--quiet]` | report chezmoi/mise drift; exit non-zero if unhealthy |
| `dg machine doctor` | verbose diagnostics (chezmoi/mise doctor + versions) |
| `dg machine repair` | `chezmoi apply` (+ `mise install`) — local, no pull |
| `dg machine update` | pull newer source + apply + upgrade brews/mise |
| `dg machine bootstrap` | first-time setup on a fresh machine (idempotent) |

## Escape hatches

- `~/.gitconfig.local` — last-include-wins overrides for git
- `~/.zshrc.d/99.local.zsh` — unmanaged drop-in for machine-specific aliases
- `~/.config/mise/conf.d/*.toml` — personal mise overrides
