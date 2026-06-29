#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

check_lesspipe() {
  if has_cmd lesspipe.sh archive_color; then
    return 0
  fi
  return 1
}

_install_lesspipe() {
  local lesspipe_dir man_folder completion_folder

  # Clone/pull the repo
  lesspipe_dir="$XDG_DATA_HOME/lesspipe"
  clone_or_pull "wofr06/lesspipe" "$lesspipe_dir"

  # Symlink lesspipe.sh and archive_color into XDG_BIN_HOME
  info "Symlinking"
  ln -sf "$lesspipe_dir/lesspipe.sh" "$XDG_BIN_HOME/lesspipe.sh"
  ln -sf "$lesspipe_dir/archive_color" "$XDG_BIN_HOME/archive_color"

  # Symlink the man page
  info "Adding man-page"
  man_folder=$XDG_MAN_HOME/man1
  mkdir -p "$man_folder"
  ln -sf "$lesspipe_dir/lesspipe.1" "$man_folder/lesspipe.1"
  mandb -u -q

  # Replace '__LIBEXECDIR__' with the location to lesscomplete, and pipe the content into a completion-file
  info "Creating completions"
  local completion_folder=$ZDOTDIR/completions
  mkdir -p "$completion_folder"
  < "$lesspipe_dir/zsh_completion" sed "s@__LIBEXECDIR__@$lesspipe_dir@" >| "$completion_folder/_less"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  force_install=${FORCE_INSTALL:-0}

  # If lesspipe is not installed, then we install it.
  # If lesspipe is installed and FORCE_INSTALL is set to true, we also install
  should_install=0
  check_lesspipe || should_install=1
  check_lesspipe && is_true "$force_install" && should_install=1

  if is_true "$should_install"; then
    info "Installing lesspipe"
    _install_lesspipe && success "lesspipe installed"
  else
    info "lesspipe is already installed. Run update-script to update"
  fi
fi
