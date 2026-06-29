#!/usr/bin/env bash

mkdir -p "$TMUX_CONFIG"

clone_or_pull "tmux-plugins/tpm" "$TMUX_PLUGIN_MANAGER_PATH/tpm"
ln -sf "$DOTFILES/tmux/tmux.conf" "$TMUX_CONFIG/tmux.conf"
