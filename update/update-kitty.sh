#!/usr/bin/env bash

source "$DOTFILES/bootstrap"
kitty_version=""

_check_version() {
  local current_version new_version
  current_version=$(kitty --version | grep -Po "(\d+\.)+\d+")
  new_version=$(download "https://sw.kovidgoyal.net/kitty/current-version.txt")

  if [ "$current_version" = "$new_version" ]; then
    kitty_version=$current_version
  fi
}

if ! has_cmd kitty; then
  warning_severe "kitty is not installed. Run the install-script"
else
  _check_version

  if [[ -n $kitty_version ]]; then
    success "Newest version of kitty already installed: $kitty_version"
  else
    info "Updating kitty"
    source "$DOTFILES/install/install-kitty.sh"
    _install_kitty && success "Kitty updated"
  fi
fi