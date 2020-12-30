#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

bind '"jj": vi-movement-mode'

source "$(dirname $(readlink -f ${BASH_SOURCE[0]}))/etc/common.sh" bash

readonly COLOR_RED="\[$(tput setaf 1)\]"
readonly COLOR_GREEN="\[$(tput setaf 2)\]"
readonly COLOR_BLUE="\[$(tput setaf 4)\]"
readonly COLOR_PURPLE="\[$(tput setaf 5)\]"
readonly COLOR_RESET="\[$(tput sgr0)\]"

## prompt
function prompt {
  local -r exit_code=$?
  local start_color
  if [ $exit_code -eq 0 ]; then
    start_color=$COLOR_PURPLE
  else
    start_color=$COLOR_RED
  fi
  PS1="\n$COLOR_BLUE\w\n$start_color❯$COLOR_RESET "
}

PROMPT_COMMAND='prompt'
