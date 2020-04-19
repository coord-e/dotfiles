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

## aliases
alias ls='ls --color=auto'
alias la='ls -la'
alias l='ls -F'
alias xclip='xclip -selection clipboard'
alias vi='vim'
alias tolower='tr "[:upper:]" "[:lower:]"'
alias toupper='tr "[:lower:]" "[:upper:]"'
alias printvar='set -o posix; set'
alias mkdir='mkdir -p'
alias gdb='gdb -q'
alias df='df -h'
alias du='du -ch'
alias cperm='find . \( -type f -exec chmod 0644 {} + \) -or \( -type d -exec chmod 0755 {} + \)'
alias mkbookpdf="mkbookpdf -I"

alias ssend="slackcat --channel memo"

## platform detection
export PLATFORM
case "$(uname | tolower)" in
  *'linux'*)  PLATFORM='linux'   ;;
  *'darwin'*) PLATFORM='macos'   ;;
  *'bsd'*)    PLATFORM='bsd'     ;;
  *)          PLATFORM='unknown' ;;
esac

export DISTRO
export DISTRO_VERSION
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    DISTRO=$NAME
    DISTRO_VERSION=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    DISTRO=$(lsb_release -si)
    DISTRO_VERSION=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
    DISTRO_VERSION=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    DISTRO=Debian
    DISTRO_VERSION=$(cat /etc/debian_version)
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    DISTRO=$(uname -s)
    DISTRO_VERSION=$(uname -r)
fi

function sourceif() {
  [ -e $1 ] && source $@ || true
}

function evalif() {
  type $1 >/dev/null 2>&1 && eval "$2" || true
}

evalif nvim 'export VISUAL=nvim'
evalif vim 'export VISUAL=vim'

export LANG=en_US.UTF-8
export EDITOR="$VISUAL"

export GOPATH="$HOME/go"

## platform dependent configuration
case "$PLATFORM" in
    *'linux'*)
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        alias open='xdg-open'
        export PATH="$PATH:$HOME/.linuxbrew/bin"
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        ;;
    *'macos'*)
        export SHELL='/usr/local/bin/zsh'
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
        export THEOS="$HOME/theos"
        ;;
esac

## PATH
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:./node_modules/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.4.0/bin"
export PATH="$PATH:$HOME/.rbenv/bin"
export PATH="$PATH:/opt/cling/bin"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/lib/ccache/:$PATH"
export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
export PATH="$PATH:/bin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/usr/local/bin"
evalif brew 'export PATH="$PATH:$(brew --prefix)/bin"'
evalif brew 'export PATH="$PATH:$(brew --prefix)/opt/fzf/bin"'

## Setup tools
### pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
evalif pyenv 'eval "$(pyenv init -)"'
evalif pyenv 'eval "$(pyenv virtualenv-init -)"'

### rbenv
evalif rbenv 'eval "$(rbenv init -)"'

### hub
evalif hub 'eval "$(hub alias -s)"'

### direnv
evalif direnv 'eval "$(direnv hook zsh)"'

### awscli
evalif pyenv 'sourceif "$(pyenv which aws_zsh_completer.sh)"'

### azure-cli
sourceif "$HOME/lib/azure-cli/az.completion"

### google-cloud-sdk
sourceif "$HOME/.google-cloud-sdk/completion.zsh.inc"
sourceif "$HOME/.google-cloud-sdk/path.zsh.inc"

### gvm
sourceif "$HOME/.gvm/scripts/gvm"

### nvm
export NVM_DIR="$HOME/.nvm"
sourceif "$NVM_DIR/nvm.sh"
evalif brew 'sourceif "$(brew --prefix nvm)/nvm.sh"'

### travis-cli
sourceif "$HOME/.travis/travis.sh"

### fzf
sourceif "$HOME/.fzf.zsh"
sourceif "/usr/share/fzf/completion.zsh"
evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/completion.zsh"'

# loaded after zprezto
# sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
# sourceif "/usr/share/fzf/key-bindings.zsh"

### opam
sourceif "$HOME/.opam/opam-init/init.zsh"  >/dev/null 2>&1

### nix
sourceif "$HOME/.nix-profile/etc/profile.d/nix.sh"

### ghcup
sourceif "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

### ccache
export USE_CCACHE=1
export CCACHE_DIR="$HOME/.ccache"

### lynx
export LYNX_CFG="$HOME/.lynxrc"

### perl
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

## utility functions
function git-retag() {
  git tag -d $1
  git tag $1
}

function mkcd() {
  mkdir "$1"
  cd "$1"
}

function cpd() {
  local -r src="$1"
  shift

  for dist in "$@"; do
    cp "$src" "$dist"
  done
}

function screenshot() {
  local -r file="$(mktemp --tmpdir XXXX.png)"
  maim "$@" >| "$file"
  ssend "$file"
}

function set_mode() {
  set -x

  cvt $1 $2 $3 | tail -n1 | sed -e "s/Modeline //" | xargs xrandr --newmode
  xrandr --addmode HDMI-1 "${1}x${2}_${3}.00"
  xrandr --output HDMI-1 --mode ${1}x${2}_${3}.00 --primary --auto --right-of LVDS-1
}

function recd() {
  cd "$PWD"
}

## error logging
export ERRLOGPATH="$HOME/logs"
mkdir "$ERRLOGPATH"

function _le {
  local file="$(mktemp)"

  # Run the supplied command in screen, and print the exit code on exit
  local screen_cmd='trap '"'"'echo -en "\n"$?'"'"' EXIT; '$@
  screen -Logfile "$file" -L bash -c "$screen_cmd"

  # Overwrite "screen is terminating" message with empty
  echo -ne '\033[F'
# echo -n "[screen is terminating]"
  echo -n "                       "

  # Last line shows the exit code
  local -r exit_status=$(tail -1 "$file" | tr -d '[:space:]')
  sed -i '$d' "$file"

  # Show the log as if it was directly printed to console
  cat "$file"

  if [ "$exit_status" == "0" ]; then
    # If the command succeeded, remove the log
    rm "$file"
  else
    mkdir -p $ERRLOGPATH
    local uuid=$(python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)')
    local cmd=$(echo "$@" | cut -d ' ' -f1 | tr -d '[:space:]')
    local new_file="$ERRLOGPATH/$cmd-$exit_status-$uuid.log"
    mv "$file" "$new_file"
    echo "Saved to $new_file"
  fi
  return $exit_status
}

function log_error_proc {
  if [[ -n "$BUFFER" ]]; then
    local cmd=$(echo "$BUFFER" | cut -d ' ' -f1 | tr -d '[:space:]')
    local targets=(clang clang++ gcc g++ python make cmake go cargo rustc node yarn npm pipenv pip docker docker-compose)
    if [[ ${targets[(r)$cmd]} == $cmd ]]; then
        BUFFER="_le $BUFFER"
    fi
  fi
  zle .$WIDGET "$@"
}
# zle -N accept-line log_error_proc

## zprezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

## overwrite keybinds...conflict with prezto?
bindkey -M viins 'jj' vi-cmd-mode
evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"'
sourceif "/usr/share/fzf/key-bindings.zsh"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
sourceif "$HOME/.sdkman/bin/sdkman-init.sh"
