# contains common configuration in several shells

export SHELL_NAME=$1

## aliases
alias ls='ls --color=auto'
alias la='ls -la'
alias l='ls -F'
alias xclip='xclip -selection clipboard'
alias mkdir='mkdir -p'
alias gdb='gdb -q'
alias df='df -h'
alias du='du -ch'
alias mkbookpdf="mkbookpdf -I"

alias ssend="slackcat --channel memo"

## platform detection
export PLATFORM
case $(uname | tr '[:upper:]' '[:lower:]') in
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
### nix
sourceif "$HOME/.nix-profile/etc/profile.d/nix.sh"

### pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
evalif pyenv 'eval "$(pyenv init -)"'
evalif pyenv 'eval "$(pyenv virtualenv-init -)"'

### rbenv
evalif rbenv 'eval "$(rbenv init -)"'

### hub
evalif hub 'eval "$(hub alias -s)"'

### gvm
sourceif "$HOME/.gvm/scripts/gvm"

### nvm
export NVM_DIR="$HOME/.nvm"
sourceif "$NVM_DIR/nvm.sh"
evalif brew 'sourceif "$(brew --prefix nvm)/nvm.sh"'

### travis-cli
sourceif "$HOME/.travis/travis.sh"

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

# SDKMAN!
export SDKMAN_DIR="$HOME/.sdkman"
sourceif "$HOME/.sdkman/bin/sdkman-init.sh"

case "$SHELL_NAME" in
    'bash')
        ### direnv
        evalif direnv 'eval "$(direnv hook bash)"'
        ### fzf
        sourceif "/usr/share/fzf/completion.bash"
        evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/completion.bash"'
        sourceif "/usr/share/fzf/key-bindings.bash"
        evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"'
        ### opam
        sourceif "$HOME/.opam/opam-init/init.bash"  >/dev/null 2>&1
        ;;
    'zsh')
        ### direnv
        evalif direnv 'eval "$(direnv hook zsh)"'
        ### fzf
        sourceif "/usr/share/fzf/completion.zsh"
        evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/completion.zsh"'
        sourceif "/usr/share/fzf/key-bindings.zsh"
        evalif brew 'sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"'
        ### opam
        sourceif "$HOME/.opam/opam-init/init.zsh"  >/dev/null 2>&1
        ;;
esac

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

function curlat() {
  pushd "$1" > /dev/null
  shift
  curl "$@" -O
  popd > /dev/null
}
