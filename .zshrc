#
# ~/.zshrc
#

## zsh configurations
setopt IGNOREEOF
autoload -Uz colors
colors

fpath=(~/.zsh/completion $fpath)

autoload -Uz compinit
compinit

bindkey -v

export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=100000

setopt complete_aliases
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expand
setopt inc_append_history
setopt EXTENDED_HISTORY

source "${${(%):-%N}:A:h}/etc/common.sh" zsh

## zprezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

## overwrite keybinds...conflict with prezto?
bindkey -M viins 'jj' vi-cmd-mode
evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"'
sourceif "/usr/share/fzf/key-bindings.zsh"
