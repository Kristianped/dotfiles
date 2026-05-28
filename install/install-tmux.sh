#!/usr/bin/env bash

tmux_dir="$XDG_CONFIG_HOME/tmux"
plugins_dir="$tmux_dir/plugins/tpm"

if [[ ! -d $tmux_dir ]]; then
  mkdir -p "$tmux_dir"
  clone_or_pull "tmux-plugins/tpm" "$plugins_dir"
  "$plugins_dir/bin/install_plugins"
fi

clone_or_pull "tmux-plugins/tpm" "$plugins_dir"
ln -sf "$DOTFILES/tmux/tmux.conf" "$tmux_dir/tmux.conf"
