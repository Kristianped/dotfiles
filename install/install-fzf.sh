#!/usr/bin/env bash

# Clone/pull the remote repositories
clone_or_pull "junegunn/fzf" "$FZF_PATH"
clone_or_pull "junegunn/fzf-git.sh" "$FZF_GIT_PATH"

# Base directory for fzf
fzf_base="$FZF_PATH"
FZF_CONFIG_PATH="$XDG_CONFIG_HOME/fzf"

# Options for tar when downloading binary
tar_opts="-xzf -"
if tar --no-same-owner -tf /dev/null 2> /dev/null; then
  tar_opts="--no-same-owner $tar_opts"
fi

# Any errors when downloading binary is stored in this
binary_error=""

try_download() {
  if [[ $1 =~ tar.gz$ ]]; then
    download $1 | tar $tar_opts
  else
    local temp=$(download -o -t -f=fzf.zip $1)
    unzip -o "$temp" && rm -f "$temp"
  fi
}

_check_binary() {
  echo -n "  - Checking fzf executable ... "
  local version output
  version=$1
  output=$(FZF_DEFAULT_OPTS= "$fzf_base"/bin/fzf --version 2>&1)
  if [ $? -ne 0 ]; then
    echo "Error: $output"
    binary_error="Invalid binary"
  else
    output=${output/ */}
    if [ "$version" != "$output" ]; then
      echo "$output != $version"
      binary_error="Invalid version"
    else
      echo "$output"
      binary_error=""
      return 0
    fi
  fi
  rm -f "$fzf_base"/bin/fzf
  return 1
}

_download_binary() {
  local version bin_dir
  version=$1
  bin_dir="$fzf_base/bin"

  mkdir -p "$bin_dir"
  (
    # cd info the bin directory
    cd "$bin_dir" || {
      binary_error="Failed to create bin directory"
      return 1
    }

    # Downloading the binary
    echo "Downloading bin/fzf ..."
    file=fzf-$version-linux_amd64.tar.gz
    url=https://github.com/junegunn/fzf/releases/download/v$version/$file

    set -o pipefail
    if ! try_download "$url"; then
      set +o pipefail
      binary_error="Failed to download with curl and wget"
      return 1
    fi
    set +o pipefail

    # If the binary is not in the directory
    if [[ ! -f fzf ]]; then
      binary_error="Failed to download $file"
      return 1
    fi
  )
}

_find_version() {
  (
    cd "$fzf_base" || {
      binary_error="Could not find fzf directory"
      return
    }

    echo $(git describe --abbrev=0 2> /dev/null | sed "s/^v//")
  )
}

_download_fzf() {
  local version file url

  # If the binary exist, we delete it
  if [ -x "$fzf_base"/bin/fzf ]; then
    echo "Binary exists, deleting it"
    rm -f "$fzf_base"/bin/fzf
  fi

  # Get the version
  version=$(_find_version)
  if [[ -z $version ]]; then
    binary_error="Failed to find version"
    return
  fi
  echo "Version for fzf: $version"

  # Download the binary
  _download_binary "$version" && chmod +x "$fzf_base/bin/fzf" && _check_binary "$version"
}

# fzf git repository does not contain the main fzf-binary, must be downloaded
echo ""
_download_fzf

if [ -n "$binary_error" ]; then
  echo "  - $binary_error !!!"
fi


# Create symlinks
ln -sf "$DOTFILES/fzf/fzf.zsh" "$FZF_CONFIG_PATH/fzf.zsh"
