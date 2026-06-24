#!/usr/bin/env bash

# Clone/pull the repo
lesspipe_dir="$XDG_DATA_HOME/lesspipe"
clone_or_pull "wofr06/lesspipe" "$lesspipe_dir"

# Symlink lesspipe.sh and archive_color into XDG_BIN_HOME
ln -sf "$lesspipe_dir/lesspipe.sh" "$XDG_BIN_HOME/lesspipe.sh"
ln -sf "$lesspipe_dir/archive_color" "$XDG_BIN_HOME/archive_color"

# Symlink the man page
man_folder=$XDG_MAN_HOME/man1
[[ -d $man_folder ]] || mkdir -p "$man_folder"
ln -sf "$lesspipe_dir/lesspipe.1" "$man_folder/lesspipe.1"
mandb -u -q

# Replace '__LIBEXECDIR__' with the location to lesscomplete, and pipe the content into a completion-file
mkdir -p "$ZDOTDIR/completions"
< "$lesspipe_dir/zsh_completion" sed "s@__LIBEXECDIR__@$lesspipe_dir@" >| "$ZDOTDIR/completions/_less"
