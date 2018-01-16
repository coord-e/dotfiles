#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -la'
alias l='ls -F'
alias open='xdg-open'
alias xclip='xclip -selection clipboard'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias vi='vim'
alias tolower='tr "[:upper:]" "[:lower:]"'
alias toupper='tr "[:lower:]" "[:upper:]"'

export PLATFORM
case "$(uname | tolower)" in
  *'linux'*)  PLATFORM='linux'   ;;
  *'darwin'*) PLATFORM='osx'     ;;
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

# export PYENV_ROOT=$HOME/.pyenv
# export PATH=$PYENV_ROOT/bin:$PATH
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

case "$PLATFORM" in
    *'linux'*)
        export PATH="$HOME/.linuxbrew/bin:$PATH"
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        ;;
    *'darwin'*)
        ;;
esac


function length()
{
  echo -n ${#1}
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

eval "$(direnv hook bash)"

export PATH=$PATH:$(brew --prefix)/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$(brew --prefix)/opt/fzf/bin
export PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin

complete -C "$(which aws_completer)" aws
source $HOME/.travis/travis.sh
source $HOME/lib/azure-cli/az.completion
source $(brew --prefix)/etc/bash_completion.d/*
source "$(brew --prefix)/opt/fzf/shell/completion.bash" 2> /dev/null
source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
source $HOME/.google-cloud-sdk/completion.bash.inc
source $HOME/.google-cloud-sdk/path.bash.inc

git-add-untracked () {
  FILES=$(git ls-files --others --exclude-standard $1)
  echo $FILES | sed '/^$/d'
  echo "Adding $(echo ${FILES:+$FILES" "} | grep -o " " | grep -c ^ |
sed '/^$/d') files"
  echo $FILES | xargs git add
}

lldb-lt() {
  CORE_PATH="/var/cores/$(ls -t /var/cores/ | head -n 1)"
  LAST_CMD=$(history 2 | head -n 1 | awk '{print $2;}')
  if [ -z "$1" ]; then
    lldb $LAST_CMD -c $CORE_PATH
  else
    lldb $1 -c $CORE_PATH
  fi
}

PROMPT_COMMAND=__prompt_command
__prompt_command() {
    EXIT=$?

    PS1="\n\033]0;\w\007\[\033[01;34m\]\w\[\033[00m\] \[\e[01;35m\]$PS1_GIT_BRANCH \[\e[01;96m\]$PS1_GIT_ARROWS"

    if [ $EXIT -eq 0 ]; then
        PS1+="\[\e[01;32m\]"
    else
        PS1+="\[\e[01;31m\]"
    fi
    PS1+="\n❯\[\e[00m\] "
}

#fortune | pokemonsay -n
