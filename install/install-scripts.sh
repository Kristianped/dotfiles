#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

SCRIPTS_FOLDER=$XDG_BIN_HOME

# Create the folder for the scripts if not exist
[[ ! -d $SCRIPTS_FOLDER ]] && mkdir -p $SCRIPTS_FOLDER

# If the scripts-folder is not on the path, we add it
[[ ! :$PATH: == *:"$SCRIPTS_FOLDER": ]] && export PATH="$SCRIPTS_FOLDER:$PATH"

# Remove broken symlinks
remove_broken_symlinks $SCRIPTS_FOLDER

# Symlink every script-file into the scripts-folder
ln -sf $DOTFILES/scripts/* $SCRIPTS_FOLDER/
