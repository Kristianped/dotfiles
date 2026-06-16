#!/usr/bin/env bash

# Create directories
[[ ! -d $ZDOTDIR ]] && mkdir -p "$ZDOTDIR"

# Set up symlinks
ln -sf "$DOTFILES/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES/zsh/zshenv" "$ZDOTDIR/.zshenv"
ln -sf "$DOTFILES/zsh/zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$DOTFILES/zsh/zprofile" "$ZDOTDIR/.zprofile"
ln -sf "$DOTFILES/zsh/dircolors" "$ZDOTDIR/dircolors"
