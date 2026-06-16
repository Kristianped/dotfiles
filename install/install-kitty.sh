#!/usr/bin/env bash

source "$DOTFILES/bootstrap"
kitty_home="$XDG_DATA_HOME/kitty.app"

# Any errors when downloading binary is stored in this
kitty_error=""

# Check if Kitty is installed, and the version
_check_kitty() {
  if has_cmd kitty; then
    local current_version new_version
    current_version=$(kitty --version | grep -Po "(\d+\.)+\d+")
    new_version=$(download "https://sw.kovidgoyal.net/kitty/current-version.txt")

    if [ "$current_version" = "$new_version" ]; then
      kitty_error="Newest version of kitty already installed: $current_version"
    fi
  fi
}

_install_kitty() {
  local url file_name

  # Download the installer
  url="https://sw.kovidgoyal.net/kitty/installer.sh"
  file_name=$(download -o -f=kitty-installer.sh $url)

  # Run the installer
  chmod 0777 "$file_name"
  "$file_name" "dest=$XDG_DATA_HOME" "launch=n"
}

_configure_kitty() {
  local applications_home theme_file terminal_file

  if [[ ! -f "$kitty_home/bin/kitty" ]]; then
    kitty_error="Failed to find binary file for Kitty"
    return
  fi

  applications_home="$XDG_DATA_HOME/applications"
  theme_file=$XDG_CONFIG_HOME/kitty/current_theme.conf
  terminal_file="$XDG_CONFIG_HOME/xdg-terminals.list"

  # Create symlinks
  mkdir -p "$XDG_CONFIG_HOME/kitty"
  ln -sf "$kitty_home"/bin/* "$XDG_BIN_HOME/"
  ln -sf "$DOTFILES/kitty/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"

  if [ -L "$theme_file" ] && [ ! -e "$theme_file" ]; then
    # If theme_file is a symlink, we overwrite it only if broken
    ln -sf "$DOTFILES/kitty/default_color.conf" "$theme_file"
  fi

  # Place the kitty.desktop file somewhere it can be found by the OS
  cp "$kitty_home/share/applications/kitty.desktop" "$applications_home/kitty.desktop"

  # Update the paths to the kitty and its icon in the kitty desktop file(s)
  sed -i "s|Icon=kitty|Icon=$kitty_home/share/icons/hicolor/256x256/apps/kitty.png|g" "$applications_home"/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$kitty_home/bin/kitty|g" "$applications_home"/kitty*.desktop

  # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
  if [[ -f $terminal_file ]]; then
    grep -qxF "kitty.desktop" "$terminal_file" || echo "kitty.desktop" >> "$terminal_file"
  else
    echo "kitty.desktop" >| "$terminal_file"
  fi

  mandb -u -q
}

_check_kitty

if [ -z "$kitty_error" ]; then
  _install_kitty
  wait
  _configure_kitty
fi

if [ -n "$kitty_error" ]; then
  echo "$kitty_error"
fi
