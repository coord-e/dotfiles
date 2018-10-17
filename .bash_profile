#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ "$PLATFORM" = "macos" ]; then
  export PATH=/usr/local/bin:${PATH}
  export MANPATH=/usr/local/share/man:${MANPATH}
  export PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
  export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
fi

export PATH="$HOME/.bd/bin:$PATH"
