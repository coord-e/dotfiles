#
# ~/.zshrc
#

bindkey -M viins 'jj' vi-cmd-mode

setopt IGNOREEOF
autoload -Uz colors
colors

autoload -Uz compinit
compinit

bindkey -v # vi keybind

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct

alias ls='ls --color=auto'
alias la='ls -la'
alias l='ls -F'
alias xclip='xclip -selection clipboard'
alias vi='vim'
alias tolower='tr "[:upper:]" "[:lower:]"'
alias toupper='tr "[:lower:]" "[:upper:]"'
alias printvar='set -o posix; set'
alias git-ls-untracked='git ls-files --other --exclude-standard'
alias mkdir='mkdir -p'
alias gdb='gdb -q'
alias df='df -h'
alias du='du -ch'
alias cperm='find . \( -type f -exec chmod 0644 {} + \) -or \( -type d -exec chmod 0755 {} + \)'

alias ghci='stack ghci'
alias ghc='stack ghc --'
alias runghc='stack runghc --'

alias ssend="slack file upload --channels '@coord.e'"
alias psend="tmux saveb - | ssend --title 'clipboard' > /dev/null"

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

export VISUAL=vim
export EDITOR="$VISUAL"

if [ "$PLATFORM" = "macos" ]; then
  export SHELL='/usr/local/bin/zsh'
else
  export SHELL='/bin/zsh'
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

eval "$(hub alias -s)"
eval "$(direnv hook zsh)"

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

powerline-daemon -q
source $HOME/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh

sourceif $(which aws_zsh_completer.sh)
sourceif $HOME/.travis/travis.sh
sourceif $HOME/lib/azure-cli/az.completion
sourceif "$(brew --prefix)/opt/fzf/shell/completion.zsh"
sourceif "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
sourceif $HOME/.fzf.zsh
sourceif $HOME/.google-cloud-sdk/completion.zsh.inc
sourceif $HOME/.google-cloud-sdk/path.zsh.inc
sourceif $HOME/.gvm/scripts/gvm

export NVM_DIR="$HOME/.nvm"
sourceif "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
sourceif "$(brew --prefix nvm)/bash_completion"

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expand
setopt inc_append_history
setopt EXTENDED_HISTORY

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

if [ ! -v TMUX ]; then
if type fortune pokemonsay >/dev/null 2>&1; then
  fortune | pokemonsay -n
fi
fi

# added by travis gem
[ -f /home/coorde/.travis/travis.sh ] && source /home/coorde/.travis/travis.sh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/coorde/.sdkman"
[[ -s "/home/coorde/.sdkman/bin/sdkman-init.sh" ]] && source "/home/coorde/.sdkman/bin/sdkman-init.sh"

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
