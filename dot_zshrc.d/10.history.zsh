#!/usr/bin/env zsh
# History behavior. Loads first so later modules (atuin, completions, plugins)
# build on a consistent history.

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS   # collapse repeated commands to the newest entry
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY          # live-share history across open shells
setopt EXTENDED_HISTORY       # record timestamps
