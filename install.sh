#!/usr/bin/env bash

set -o errexit
set -o pipefail

############
# includes #
############

install_dir="$(dirname "$(readlink -f "$0")")"
source "$install_dir/bootstrap"
source "$install_dir/zsh/zshenv"

################
# presentation #
################

skull=$(<"$install_dir/skull.txt")
mes_color "$MAGENTA" "$skull"
echo
mes_color "$YELLOW" "!!! WARNING !!!"
mes_color "$LIGHT_RED" "This script will delete all your configuration files!"
mes_color "$LIGHT_RED" "Use it at your own risks."

if ! prompt_ask; then
  exit 0
fi

###########
# INSTALL #
###########

# Install scripts
dot_install scripts

# Install Mise
dot_install mise

# Install bat-extras, lesspipe and fzf
has_cmd bat && dot_install bat-extras
dot_install lesspipe
dot_install fzf

# Install Kitty
dot_install kitty

# Install fonts
dot_install fonts

# Install zsh
dot_install completions
dot_install zsh

# Install nvim
dot_install nvim

# Install man-pages
dot_install man

# Install other stuff
has_cmd git && dot_install git
has_cmd tmux && dot_install tmux
has_cmd pgcli && dot_install pgcli
