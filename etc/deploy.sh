#!/usr/bin/env bash
find . -name '.*' ! -path . ! -path ./.git ! -path ./.gitignore | xargs -I% ln -frsnv % ~/
find config/ -maxdepth 1 ! -path config/ | xargs -I% ln -frsnv % ~/.config
