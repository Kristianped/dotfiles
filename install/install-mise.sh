#!/usr/bin/env bash

set -o errexit

source "$DOTFILES/bootstrap"
force_install=${FORCE_INSTALL:-0}

# Need to install Kerl for Erlang
if ! has_cmd kerl; then
  download "https://raw.githubusercontent.com/kerl/kerl/master/kerl" >| "$XDG_BIN_HOME/kerl"
  chmod 0777 "$XDG_BIN_HOME/kerl"
fi

_install() {
  local url file_name dir_name gpg_home
  # If mise is already installed, we remove it first
  if has_cmd mise; then
    mise implode --config --yes
    wait
  fi

  # Download the installer
  url="https://mise.run"
  file_name=$(download -o -f=mise-installer.sh "$url")

  # Run the installer
  chmod 0777 "$file_name"
  MISE_INSTALL_PATH="$MISE_BIN_FILE" MISE_INSTALL_FROM_GITHUB=true "$file_name"
  wait

  # Create the global config file
  dir_name=$(dirname "$MISE_GLOBAL_CONFIG_FILE")
  mkdir -p "$dir_name"
  touch "$MISE_GLOBAL_CONFIG_FILE"

  # Ensure GNUPGHOME is created with the correct permissions
  gpg_home=${GNUPGHOME:-$XDG_DATA_HOME/gnupg}
  mkdir -p "$gpg_home"
  chmod 0700 "$gpg_home"

  # Install tools
  mise use -g bat
  mise use -g btop
  mise use -g eza
  mise use -g fd
  mise use -g fzf
  mise use -g gh
  mise use -g jq
  mise use -g pandoc
  mise use -g ripgrep
  mise use -g shfmt
  mise use -g shellcheck
  mise use -g starship
  mise use -g tmux
  mise use -g tree-sitter
  mise use -g yq

  # Install kubernetes
  mise use -g helm
  mise use -g kubectl
  mise use -g oc

  # Install Java
  mise use -g java@temurin-25
  mise use -g maven@3
  mise use -g gradle@9

  # Install node
  mise use -g node@24
  mise use -g npm:prettier
  mise use -g npm:bash-language-server

  # Install python
  mise use -g python@3.14
  mise use -g uv
  mise use -g ruff
  mise use -g pipx:black
  mise use -g pipx:build
  mise use -g pipx:clang-format
  mise use -g pipx:mmdc
  mise use -g pipx:pygments
  mise use -g pipx:pynvim

  # Install rust
  mise use -g rust@latest
  mise use -g cargo:rustfmt
  mise use -g cargo:usage-cli

  # Install other programming languages
  mise use -g go@1.23
  mise use -g lua@5.1
  mise use -g erlang@28
  mise use -g elixir@1.19.5
}

_update() {
  local old_python_version new_python_version

  # Get python-version before update
  old_python_version="0"
  has_cmd python && old_python_version=$(python --version | grep -Po "(\d+\.)+\d+")

  # Update mise
  mise self-update -y

  # Update tools
  mise install
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

# If mise is not installed, then we install it.
# If mise is installed and FORCE_INSTALL is set to true, we also install
should_install=0
has_cmd mise || should_install=1
has_cmd mise && is_true "$force_install" && should_install=1

if is_true "$should_install"; then
  info "Installing mise"
  _install
else
  info "Updating Mise"
  _update
fi
