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

# Install packages
dot_install packages

# Install Mise
dot_install mise
eval "$(mise activate bash)"

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

if ! echo "$SHELL" | grep 'zsh' >/dev/null; then
  info "Your current shell is '$SHELL'. Do you want to switch to zsh?"

  if prompt_ask; then
    chsh -s /bin/zsh
  fi
fi

info "Do you want to set a color-theme?"
if prompt_ask; then
  theme_list=("dracula" "gruvbox-dark" "nord" "tokyonight-moon" "tokyonight-storm")
  PS3="Enter a number: "
  select theme_name in "${theme_list[@]}"; do
    if [[ -z $theme_name ]]; then
      warning "Invalid theme selected: '$REPLY'"
      continue
    fi

    info "Set theme for GUI as well?"
    if prompt_ask; then
      set_theme -g "$theme_name"
    else
      set_theme "$theme_name"
    fi
    break
  done
fi

success "Installation complete"
