#!/usr/bin/env bash

# Create config-dir for btop
mkdir -p "$XDG_CONFIG_HOME/btop"

# Symlink btop config
ln -sf "$DOTFILES/btop/btop.conf" "$XDG_CONFIG_HOME/btop/btop.conf"