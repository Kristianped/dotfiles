#!/usr/bin/env bash

set -o errexit
set -o pipefail

############
# includes #
############

install_dir="$(dirname "$(readlink -f "$0")")"
source "$install_dir/zsh/zshenv"
source "$install_dir/bootstrap"
source "$install_dir/install_config"


################
# presentation #
################

skull=$(<"$install_dir/skull.txt")
mes_color "$MAGENTA" "$skull"
echo
mes_color "$YELLOW" "!!! WARNING !!!"
mes_color "$LIGHT_RED" "This script will update all configuration files set by 'install.sh'!"
mes_color "$LIGHT_RED" "Use it at your own risk."

if ! prompt_ask; then
  exit 0
fi


###########
# UPDATE #
###########

# Update scripts
dot_update scripts

# Update packages
dot_install packages

# Update Mise
dot_update mise

# Update bat-extras, lesspipe and fzf
has_cmd bat && dot_update bat-extras
dot_update lesspipe
dot_update fzf

# Update Kitty
dot_update kitty

# Update fonts
dot_install fonts

# Update zsh
dot_install completions
dot_install zsh

# Update nvim
dot_update nvim

# Update man-pages
dot_install man

# Update other stuff
has_cmd git && dot_install git
has_cmd tmux && dot_install tmux
has_cmd pgcli && dot_install pgcli

success "Update complete"
