#!/bin/bash
find . -name '.*' ! -path . ! -path ./.git ! -path ./.gitignore | xargs -I% ln -frsnv % ~/
