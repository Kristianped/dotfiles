#!/usr/bin/env bash

set -o errexit

source "$DOTFILES/bootstrap"

# Need to install Kerl for Erlang
download "https://raw.githubusercontent.com/kerl/kerl/master/kerl" >| "$XDG_BIN_HOME/kerl"
chmod 0777 "$XDG_BIN_HOME/kerl"

_install() {
  # Download the installer
  url="https://mise.run"
  file_name=$(download -o -f=mise-installer.sh $url)

  # Run the installer
  chmod 0777 "$file_name"
  MISE_INSTALL_PATH="$MISE_BIN_FILE" MISE_INSTALL_FROM_GITHUB=true "$file_name"
  wait

  # Create the global config file
  dir_name=$(dirname $MISE_GLOBAL_CONFIG_FILE)
  mkdir -p $dir_name
  ln -sf "$DOTFILES/mise/mise_config" "$MISE_GLOBAL_CONFIG_FILE"

  # Install tools
  mise install
  wait
}

_update() {
  local old_python_version new_python_version

  # Get python-version before update
  old_python_version=$(python --version | grep -Po "(\d+\.)+\d+")

  # Update mise
  mise self-update -y

  # Update tools
  mise install
  wait

  # Get python-version after update, if change we must update pipx-packages
  new_python_version=$(python --version | grep -Po "(\d+\.)+\d+")

  if [ "$old_python_version" = "$new_python_version" ]; then
    return 0
  fi

  mise install -f "pipx:*"
  wait
}

# If the mise binary file exist, we update mise. Else we install mise
if has_cmd mise; then
  info "Updating Mise"
  _update
else
  info "Installing mise"
  _install
fi
