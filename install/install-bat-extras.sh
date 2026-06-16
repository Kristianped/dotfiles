#!/usr/bin/env bash

set -o errexit

# Clone/pull the repo
bat_dir="$XDG_DATA_HOME/bat-extras"
clone_or_pull "eth-p/bat-extras" "$bat_dir" "--recurse-submodules"

# run build.sh, which will create executables in bat_dir/bin
"$bat_dir"/build.sh "--no-verify"
wait

# Symlink every executable inside bat_dir/bin into scripts_folder
if [[ -d $bat_dir/bin ]]; then
  ln -sf "$bat_dir"/bin/* "$XDG_BIN_HOME/"
fi

# Symlink every man-file inside bat_dir/man into man_folder
if [[ -d $bat_dir/man ]]; then
  man_folder=$XDG_MAN_HOME/man1
  [[ -d $man_folder ]] || mkdir -p "$man_folder"
  ln -sf "$bat_dir"/man/* "$man_folder/"
  mandb -u -q
fi
