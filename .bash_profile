#
# ~/.bash_profile
#

if [ "$PLATFORM" = "macos" ]; then
  export PATH=/usr/local/bin:${PATH}
  export MANPATH=/usr/local/share/man:${MANPATH}
  export PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
  export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/usr/local/bin:/usr/local/opt/qt5/bin:$PATH
export PKG_CONFIG_PATH=/usr/local/opt/qt5/lib/pkgconfig
export PATH="$HOME/.bd/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
