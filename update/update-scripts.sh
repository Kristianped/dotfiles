#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

info "Updating scripts"

# Remove broken symlinks
info "Removing broken symlinks"
remove_broken_symlinks "$XDG_BIN_HOME"

# Symlink every script-file into the scripts-folder
info "Symlinking every script inside $DOTFILES/scripts"
ln -sf "$DOTFILES"/scripts/* "$XDG_BIN_HOME/"

success "Scripts updated"