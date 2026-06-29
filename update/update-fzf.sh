#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

if do_action_in_dir "$FZF_PATH" git-check | grep -q "Up-to-date"; then
  success "Newest version of fzf-repo already installed"
elif do_action_in_dir "$FZF_PATH" git-check | grep -q "Need to pull"; then
  info "Updating fzf config"
  "$DOTFILES/install/install-fzf.sh"
  success "Fzf config updated"
fi
