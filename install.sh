#!/usr/bin/env zsh

############
# includes #
############

script_dir="${0:A:h}"
source "$script_dir/colors"
source "$script_dir/bootstrap"
source "$script_dir/zsh/zshenv"

################
# presentation #
################

skull=$(<"$script_dir/skull.txt")
mes_color $magenta "$skull"
echo
mes_color $yellow "!!! WARNING !!!"
mes_color $light_red "This script will delete all your configuration files!"
mes_color $light_red "Use it at your own risks."

if ! prompt_ask; then
  exit 0
fi

###########
# INSTALL #
###########

# Install scripts
dot_install scripts
has_cmd bat && dot_install bat-extras
dot_install lesspipe
dot_install fzf

# Install Mise
dot_install mise

# Install Kitty
dot_install kitty

# Install fonts
dot_install fonts

# Install zsh
dot_install completions
dot_install zsh

# Install nvim
dot_install nvim

# Install other stuff
has_cmd git && dot_install git
has_cmd tmux && dot_install tmux
has_cmd pgcli && dot_install pgcli
