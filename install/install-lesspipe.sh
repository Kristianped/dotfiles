#!/usr/bin/env bash

# Clone/pull the repo
lesspipe_dir="$XDG_DATA_HOME/lesspipe"
clone_or_pull "wofr06/lesspipe" "$lesspipe_dir"


# Symlink lesspipe.sh and archive_color into XDG_BIN_HOME
ln -sf "$lesspipe_dir/lesspipe.sh" "$XDG_BIN_HOME/lesspipe.sh"
ln -sf "$lesspipe_dir/archive_color" "$XDG_BIN_HOME/archive_color"

# Symlink the man page
ln -sf "$lesspipe_dir/lesspipe.1" "$XDG_DATA_HOME/man/man1/lesspipe.1"

# Replace '__LIBEXECDIR__' with the location to lesscomplete, and pipe the content into a completion-file
cat "$lesspipe_dir/zsh_completion" | sed "s@__LIBEXECDIR__@$lesspipe_dir@" > $DOTFILES/zsh/completions/_less
