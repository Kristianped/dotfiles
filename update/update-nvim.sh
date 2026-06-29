#!/usr/bin/env bash

source "$DOTFILES/install/install-nvim.sh"
nvim_version=""

_check_nvim_version() {
  local bin_folder bin_file
  bin_folder=$NVIM_HOME/bin
  bin_file=$bin_folder/nvim

  local local_version new_version
  local_version=$("$bin_file" --version | grep "NVIM v" | sed 's/NVIM//g')
  new_version=$(curl --silent "https://api.github.com/repos/neovim/neovim/releases/latest" | grep '"tag_name"' |  sed -E 's/.*"([^"]+)".*/\1/')

  local_version=$(trim_string "$local_version")
  new_version=$(trim_string "$new_version")

  if [ "$local_version" = "$new_version" ]; then
    nvim_version=$local_version
  fi
}

if ! _check_nvim; then
  warning_severe "nvim is not installed. Run the install-script"
else
  _check_nvim_version

  if [[ -n $nvim_version ]]; then
    success "Newest version of nvim already installed: $nvim_version"
  else
    info "Updating nvim"
    _install_latest
  fi

  _symlink_folders
  success "nvim updated"
fi