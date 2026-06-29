#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

_update() {
  local old_python_version new_python_version

  # Get python-version before update
  old_python_version="0"
  has_cmd python && old_python_version=$(python --version | grep -Po "(\d+\.)+\d+")

  # Update mise
  mise self-update -y

  # Update tools
  mise upgrade
  wait

  # Get python-version after update, if change we must update pipx-packages
  if has_cmd python; then
    new_python_version=$(python --version | grep -Po "(\d+\.)+\d+")

    if [ "$old_python_version" = "$new_python_version" ]; then
      return 0
    fi

    mise install -f "pipx:*"
    wait
  fi
}

if ! has_cmd mise; then
  warning_severe "Mise is not installed. Run the install-script"
else
  info "Updating Mise"
  _update && success "Mise updated"
fi