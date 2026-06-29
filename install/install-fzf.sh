#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

# Clone/pull the remote repositories
clone_or_pull "junegunn/fzf" "$FZF_PATH"
clone_or_pull "junegunn/fzf-git.sh" "$FZF_GIT_PATH"

# Create symlinks
info "Symlinking"
mkdir -p "$FZF_CONFIG_PATH"
ln -sf "$DOTFILES/fzf/fzf.zsh" "$FZF_CONFIG_PATH/fzf.zsh"
ln -sf "$FZF_PATH/bin/fzf-preview.sh" "$XDG_BIN_HOME/fzf-preview"
ln -sf "$FZF_PATH/bin/fzf-tmux" "$XDG_BIN_HOME/fzf-tmux"

# Symlink the man page
info "Adding man-page"
man_folder=$XDG_MAN_HOME/man1
mkdir -p "$man_folder"
ln -sf "$FZF_PATH/man/man1/fzf.1" "$man_folder/fzf.1"
ln -sf "$FZF_PATH/man/man1/fzf-tmux.1" "$man_folder/fzf-tmux.1"
mandb -u -q