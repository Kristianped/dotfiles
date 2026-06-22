#!/usr/bin/env bash

tmux_theme="Nord"
declare -A theme_options

[[ -f $TMUX_CONFIG/theme ]] && source "$TMUX_CONFIG/theme"

dir=""
repo=""

theme=$(echo "$tmux_theme" | tr '[:upper:]' '[:lower:]')
case $theme in
  (gruvbox)
    dir=$TMUX_PLUGIN_MANAGER_PATH/gruvbox
    repo="egel/tmux-gruvbox" ;;
  (dracula)
    dir=$TMUX_PLUGIN_MANAGER_PATH/dracula
    repo="dracula/tmux" ;;
  (tokyonight)
    dir=$TMUX_PLUGIN_MANAGER_PATH/tokyonight
    repo="janoamaral/tokyo-night-tmux" ;;
  (nord)
    dir=$TMUX_PLUGIN_MANAGER_PATH/nord
    repo="arcticicestudio/nord-tmux" ;;
esac

[[ -z $repo ]] && return

clone_or_pull "$repo" "$dir"

for key in "${!theme_options[@]}"; do
  value=${theme_options[$key]}
  tmux set -g "$key" "$value"
done

tmux_files=$(find "$dir" -type f -name "*.tmux" -print)
for tmux_file in $tmux_files; do
  [ -f "$tmux_file" ] || continue
  $tmux_file >/dev/null 2>&1
done