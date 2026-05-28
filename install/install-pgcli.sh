#!/usr/bin/env bash

mkdir -p "$XDG_CONFIG_HOME/pgcli"
ln -sf "$DOTFILES/pgcli/config" "$XDG_CONFIG_HOME/pgcli/config"
