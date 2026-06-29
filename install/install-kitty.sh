#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

_install_binary() {
  local url file_name

  # Download the installer
  url="https://sw.kovidgoyal.net/kitty/installer.sh"
  file_name=$(download -o -f=kitty-installer.sh "$url")

  # Run the installer
  chmod 0777 "$file_name"
  "$file_name" "dest=$XDG_DATA_HOME" "launch=n"
}

_configure_kitty() {
  local kitty_home kitty_config_home applications_home theme_file terminal_file
  kitty_home="$XDG_DATA_HOME/kitty.app"

  if [[ ! -f "$kitty_home/bin/kitty" ]]; then
    kitty_error="Failed to find binary file for Kitty"
    return
  fi

  kitty_config_home=$XDG_CONFIG_HOME/kitty
  theme_file=$kitty_config_home/current_theme.conf

  # Create symlinks
  info "Symlinking"
  mkdir -p "$kitty_config_home"
  ln -sf "$kitty_home"/bin/* "$XDG_BIN_HOME/"
  ln -sf "$DOTFILES/kitty/kitty.conf" "$kitty_config_home/kitty.conf"

  if [ -L "$theme_file" ] && [ ! -e "$theme_file" ]; then
    # If theme_file is a symlink, we overwrite it only if broken
    ln -sf "$DOTFILES/kitty/default_color.conf" "$theme_file"
  fi

  # Place the file 'kitty.desktop' somewhere it can be found by the OS
  info "Creating desktop file"
  applications_home="$XDG_DATA_HOME/applications"
  cp "$kitty_home/share/applications/kitty.desktop" "$applications_home/kitty.desktop"

  # Update the paths to the kitty and its icon in the kitty desktop file(s)
  sed -i "s|Icon=kitty|Icon=$kitty_home/share/icons/hicolor/256x256/apps/kitty.png|g" "$applications_home"/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$kitty_home/bin/kitty|g" "$applications_home"/kitty*.desktop

  # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
  info "Updating xdg-terminals.list"
  terminal_file="$XDG_CONFIG_HOME/xdg-terminals.list"
  if [[ -f $terminal_file ]]; then
    grep -qxF "kitty.desktop" "$terminal_file" || echo "kitty.desktop" >> "$terminal_file"
  else
    echo "kitty.desktop" >| "$terminal_file"
  fi

  info "Updating man-pages"
  mandb -u -q
}

_install_kitty() {
  info "Downloading kitty binary and data"
  _install_binary
  wait
  _configure_kitty

  if [ -n "$kitty_error" ]; then
    warning_severe "$kitty_error"
    return 1
  else
    return 0
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  force_install=${FORCE_INSTALL:-0}

  # Any errors when downloading binary is stored in this
  kitty_error=""

  # If kitty is not installed, then we install it.
  # If kitty is installed and FORCE_INSTALL is set to true, we also install
  should_install=0
  has_cmd kitty || should_install=1
  has_cmd kitty && is_true "$force_install" && should_install=1

  if is_true "$should_install"; then
    info "Installing kitty"
    _install_kitty && success "Kitty installed"
  else
    info "Kitty already installed. Run update-script to update"
  fi
fi
