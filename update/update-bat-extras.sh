#!/usr/bin/env bash

set -o errexit

source "$DOTFILES/install/install-bat-extras.sh"

if ! _check_bat_extras; then
  warning_severe "bat-extras is not installed. Run the install-script"
else
  bat_dir="$XDG_DATA_HOME/bat-extras"

  if do_action_in_dir "$bat_dir" git-check | grep -q "Up-to-date"; then
    success "Newest version of bat-extras already installed"
  elif do_action_in_dir "$bat_dir" git-check | grep -q "Need to pull"; then
    info "Updating bat-extras"
    _install_bat_extras && success "bat-extras updated"
  fi
fi