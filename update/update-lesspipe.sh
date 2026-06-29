#!/usr/bin/env bash

source "$DOTFILES/install/install-lesspipe.sh"

if ! check_lesspipe; then
  warning_severe "lesspipe is not installed. Run the install-script"
else
  lesspipe_dir="$XDG_DATA_HOME/lesspipe"

  if do_action_in_dir "$lesspipe_dir" git-check | grep -q "Up-to-date"; then
    success "Newest version of lesspipe already installed"
  elif do_action_in_dir "$lesspipe_dir" git-check | grep -q "Need to pull"; then
    info "Updating lesspipe"
    _install_lesspipe && success "lesspipe updated"
  fi
fi