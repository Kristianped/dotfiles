#!/usr/bin/env bash

set -o errexit

source "$DOTFILES/bootstrap"

_check_bat_extras() {
  if has_cmd batdiff batgrep batman bat-modules batpipe batwatch prettybat; then
    return 0
  fi
  return 1
}

_install_bat_extras() {
  local bat_dir man_folder

  # Clone/pull the repo
  bat_dir="$XDG_DATA_HOME/bat-extras"
  clone_or_pull "eth-p/bat-extras" "$bat_dir" "--recurse-submodules"

  # run build.sh, which will create executables in bat_dir/bin
  "$bat_dir"/build.sh "--no-verify"
  wait

  # Symlink every executable inside bat_dir/bin into scripts_folder
  if [[ -d $bat_dir/bin ]]; then
    info "Symlinking"
    ln -sf "$bat_dir"/bin/* "$XDG_BIN_HOME/"
  fi

  # Symlink every man-file inside bat_dir/man into man_folder
  if [[ -d $bat_dir/man ]]; then
    info "Adding man-page"
    man_folder=$XDG_MAN_HOME/man1
    [[ -d $man_folder ]] || mkdir -p "$man_folder"
    ln -sf "$bat_dir"/man/* "$man_folder/"
    mandb -u -q
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  force_install=${FORCE_INSTALL:-0}

  # If bat-extras is not installed, then we install it.
  # If bat-extras is installed and FORCE_INSTALL is set to true, we also install
  should_install=0
  _check_bat_extras || should_install=1
  _check_bat_extras && is_true "$force_install" && should_install=1

  if is_true "$should_install"; then
    info "Installing bat-extras"
    _install_bat_extras && success "bat-extras installed"
  else
    info "bat-extras is already installed. Run update-script to update"
  fi
fi

