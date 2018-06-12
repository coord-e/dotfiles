#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -la'
alias l='ls -F'
alias xclip='xclip -selection clipboard'
alias vi='vim'
alias tolower='tr "[:upper:]" "[:lower:]"'
alias toupper='tr "[:lower:]" "[:upper:]"'
alias printvar='set -o posix; set'
alias git-ls-untracked='git ls-files --other --exclude-standard'
alias cperm='find . \( -type f -exec chmod 0644 {} + \) -or \( -type d -exec chmod 0755 {} + \)'

alias ghci='stack ghci'
alias ghc='stack ghc --'
alias runghc='stack runghc --'

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

export EDITOR='vim'

if [ "$PLATFORM" = "macos" ]; then
  export SHELL='/usr/local/bin/bash'
else
  export SHELL='/bin/bash'
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
  alias open='xdg-open'
fi

case "$PLATFORM" in
    *'linux'*)
        export PATH="$PATH:$HOME/.linuxbrew/bin"
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        ;;
    *'darwin'*)
        ;;
esac

function sourceif()
{
  [ -e $1 ] && source $@
}

function init-prompt-git-branch()
{
  git symbolic-ref HEAD 2>/dev/null >/dev/null &&
  echo -n "$(git symbolic-ref HEAD 2>/dev/null | sed 's/^refs\/heads\///')"
  test -n "$(git diff 2>/dev/null)" && echo -n "*"
}

function init-prompt-git-arrows()
{
  BRANCH=$(init-prompt-git-branch)
  test -n "$(git log ..origin/$BRANCH 2>/dev/null)" && echo -n "⇣"
  test -n "$(git log origin/$BRANCH.. 2>/dev/null)" && echo -n "⇡"
}

export PS1_GIT_BRANCH
export PS1_GIT_ARROWS
if which git &> /dev/null; then
  PS1_GIT_BRANCH='$(init-prompt-git-branch)'
  PS1_GIT_ARROWS='$(init-prompt-git-arrows)'
fi

export PS1="\n\033]0;\w\007\[\033[01;34m\]\w\[\033[00m\] \[\e[01;35m\]$PS1_GIT_BRANCH $PS1_GIT_ARROWS\n❯"

eval "$(hub alias -s)"
eval "$(direnv hook bash)"

export GOPATH=$HOME/.go

export PATH=$PATH:$(brew --prefix)/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$(brew --prefix)/opt/fzf/bin
export PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin
export PATH=$PATH:$HOME/.rbenv/bin
export PATH=$PATH:/opt/cling/bin
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH=/usr/local/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/bin:$PATH

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

eval "$(rbenv init -)"

complete -C "$(which aws_completer)" aws
sourceif $HOME/.travis/travis.sh
sourceif $HOME/lib/azure-cli/az.completion
sourceif $(brew --prefix)/etc/bash_completion
sourceif "$(brew --prefix)/opt/fzf/shell/completion.bash"
sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
sourceif $HOME/.fzf.bash
sourceif $HOME/.google-cloud-sdk/completion.bash.inc
sourceif $HOME/.google-cloud-sdk/path.bash.inc
sourceif $HOME/.gvm/scripts/gvm

export NVM_DIR="$HOME/.nvm"
sourceif "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
sourceif "$(brew --prefix nvm)/bash_completion"  # This loads nvm bash_completion

export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export HISTFILESIZE=100000

export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache
export PATH=/usr/lib/ccache/:$PATH

export LYNX_CFG=$HOME/.lynxrc

function git-add-untracked () {
  FILES=$(git ls-files --others --exclude-standard $1)
  echo $FILES | sed '/^$/d'
  echo "Adding $(echo ${FILES:+$FILES" "} | grep -o " " | grep -c ^ |
sed '/^$/d') files"
  echo $FILES | xargs git add
}

function lldb-lt() {
  CORE_PATH="/var/cores/$(ls -t /var/cores/ | head -n 1)"
  LAST_CMD=$(history 2 | head -n 1 | awk '{print $2;}')
  if [ -z "$1" ]; then
    lldb $LAST_CMD -c $CORE_PATH
  else
    lldb $1 -c $CORE_PATH
  fi
}

function mkempty() {
  mkdir $1
  touch $1/.gitkeep
}

# PROMPT_COMMAND=__prompt_command
export PROMPT_COMMAND="history -a; history -c; history -r; __prompt_command"
__prompt_command() {
    EXIT=$?

    if [ -n "$SSH_CLIENT" ]; then
      PS1_TEXT="remote "
    else
      PS1_TEXT=" local "
    fi

    PS1="\n\033]0;\w\007\[\033[01;34m\]\w\[\033[00m\] \[\e[01;35m\]$PS1_GIT_BRANCH \[\e[01;96m\]$PS1_GIT_ARROWS"

    if [ $EXIT -eq 0 ]; then
        PS1+="\[\e[01;32m\]"
    else
        PS1+="\[\e[01;31m\]"
    fi
    PS1+="\n${PS1_TEXT}❯\[\e[00m\] "
}

if [ ! -v TMUX ]; then
if type fortune pokemonsay >/dev/null 2>&1; then
  fortune | pokemonsay -n
fi
fi

