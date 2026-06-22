#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

# Create the folder for the scripts if not exist
[[ ! -d $XDG_BIN_HOME ]] && mkdir -p "$XDG_BIN_HOME"

# Remove broken symlinks
remove_broken_symlinks "$XDG_BIN_HOME"

# Symlink every script-file into the scripts-folder
ln -sf "$DOTFILES"/scripts/* "$XDG_BIN_HOME/"
