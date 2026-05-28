#!/usr/bin/env bash

source "$DOTFILES/bootstrap"
current_dir=$(pwd)
force_install=${FORCE_INSTALL:-0}

_install_latest() {
  local nvim_home nvim_archive applications_home

  # Remove the data-directory
  nvim_home=$XDG_DATA_HOME/nvim
  [[ -d $nvim_home ]] && rm -rf "$nvim_home"

  # Download the latest release into "nvim.tar.gz"
  nvim_archive=$(download -o -f=nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz)

  # cd into XDG_DATA_HOME, extract the archive and cd back to the current directory
  cd "$XDG_DATA_HOME" && extract -r -d "$nvim_archive" && cd "$current_dir"

  # If the directory nvim_home is not present, something went wrong
  [[ -d $nvim_home ]] || error "Something went wrong when installing the latest nvim release"

  # Add nvim.dektop to a place it can be found
  if [[ -f $nvim_home/share/applications/nvim.desktop ]]; then
    applications_home="$XDG_DATA_HOME/applications"

    # copy nvim.desktop to applications_home
    \cp $nvim_home/share/applications/nvim.desktop $applications_home/nvim.desktop

    # Update the paths to nvim-executable and icon in the nvim desktop file
    sed -i "s|Icon=nvim|Icon=$nvim_home/share/icons/hicolor/128x128/apps/nvim.png|g" $applications_home/nvim.desktop
    sed -i "s|Exec=nvim|Exec=$nvim_home/bin/nvim|g" $applications_home/nvim.desktop
  fi
}

_symlink_folder() {
  local folder_name dot_folder config_folder

  folder_name="$1"
  dot_folder="$DOTFILES/nvim/$folder_name"
  config_folder="$VIMCONFIG/$folder_name"

  [[ -d $dot_folder ]] || return 1
  [[ -d $config_folder ]] || mkdir -p "$config_folder"

  find "$dot_folder/" -maxdepth 1 -type f -exec ln -sf {} "$config_folder/" \;
}

# If nvim is not installed, then we install it.
# If nvim is installed and FORCE_INSTALL is set to true, we also install
should_install=0
has_cmd nvim || should_install=1
has_cmd nvim && is_true $force_install && should_install=1

is_true $should_install && _install_latest

_symlink_folder ""
_symlink_folder "lua/config"
_symlink_folder "lua/plugins"
_symlink_folder "lua/plugins/lang"
_symlink_folder "spell"
