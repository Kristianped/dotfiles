#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

# Iterate over files in the man-folder
for file in "$DOTFILES"/man/*; do
  # Get name of the file
  name=$(basename "$file")

  # Get file extension, ".1", ".2" etc
  ext=$(echo "$name" | awk -F . '{print $NF}')

  # Folder for the man-file; /home/user/.local/share/man/man1, /home/user/.local/share/man/man2 etc
  man_folder=$XDG_MAN_HOME/man$ext

  # Create folder if not exist
  [[ ! -d $man_folder ]] && mkdir -p "$man_folder"

  # Remove broken symlinks
  remove_broken_symlinks "$man_folder"

  # Symlink the man-file
  ln -sf "$file" "$man_folder/$name"
done

# Update mandb
mandb -u