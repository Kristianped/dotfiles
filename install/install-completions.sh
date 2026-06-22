#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

completions_folder="$ZDOTDIR/completions"
mkdir -p "$completions_folder"

# Dotnet
has_cmd dotnet && dotnet completions script zsh >| "$completions_folder/_dotnet"

# Eza
has_cmd eza && download "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza" >| "$completions_folder/_eza"

# Helm
has_cmd helm && helm completion zsh >| "$completions_folder/_helm"

# Kerl
has_cmd kerl && download "https://raw.githubusercontent.com/kerl/kerl/master/zsh_completion/_kerl" >| "$completions_folder/_kerl"

# Kubectl
has_cmd kubectl && kubectl completion zsh >| "$completions_folder/_kubectl"

# Mise
has_cmd mise && mise completion zsh >| "$completions_folder/_mise"

# Openshift
has_cmd oc && oc completion zsh >| "$completions_folder/_oc"

# Podman
has_cmd podman && podman completion zsh >| "$completions_folder/_podman"

# Pip
has_cmd pip && pip completion --zsh >| "$completions_folder/_pip"

# Procs
has_cmd procs && procs --gen-completion-out zsh >| "$completions_folder/_procs"

# If register-python-argcomplete is available it can be used to create compdef for many python programs
if has_cmd register-python-argcomplete; then
  # Pipx
  has_cmd pipx && register-python-argcomplete pipx >| "$completions_folder/_pipx"
fi

# Rust & Cargo
if has_cmd rustup; then
  rustup completions zsh >| "$completions_folder/_rustup"
  has_cmd cargo && rustup completions zsh cargo >| "$completions_folder/_cargo"
fi

# Uv and uvx
has_cmd uv && uv generate-shell-completion zsh >| "$completions_folder/_uv"
has_cmd uvx && uvx --generate-shell-completion zsh >| "$completions_folder/_uvx"

# yq
has_cmd yq && yq completion zsh >| "$completions_folder/_yq"
