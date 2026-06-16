#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

# Folder where the fonts are stored
FONT_FOLDER=$XDG_DATA_HOME/fonts

# Create folder if not exist
[[ ! -d $FONT_FOLDER ]] && mkdir -p "$FONT_FOLDER"

# Remove broken symlinks
remove_broken_symlinks "$FONT_FOLDER"

# Symlink every font-file in dotfiles-folder
ln -sf "$DOTFILES"/fonts/* "$FONT_FOLDER"/

font_update "$FONT_FOLDER"
