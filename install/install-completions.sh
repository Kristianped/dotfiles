#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

completions_array=()
completions_folder="$ZDOTDIR/completions"
mkdir -p "$completions_folder"

# Dotnet
has_cmd dotnet && dotnet completions script zsh >| "$completions_folder/_dotnet" && completions_array+=("dotnet")

# Eza
has_cmd eza && download "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza" \
  >| "$completions_folder/_eza" && completions_array+=("eza")

# Helm
has_cmd helm && helm completion zsh >| "$completions_folder/_helm" && completions_array+=("helm")

# Kerl
has_cmd kerl && download "https://raw.githubusercontent.com/kerl/kerl/master/zsh_completion/_kerl" \
  >| "$completions_folder/_kerl" && completions_array+=("kerl")

# Kubectl
has_cmd kubectl && kubectl completion zsh >| "$completions_folder/_kubectl" && completions_array+=("kubectl")

# Mise
has_cmd mise && mise completion zsh >| "$completions_folder/_mise" && completions_array+=("mise")

# Openshift
has_cmd oc && oc completion zsh >| "$completions_folder/_oc" && completions_array+=("oc")

# Podman
has_cmd podman && podman completion zsh >| "$completions_folder/_podman" && completions_array+=("podman")

# Pip
has_cmd pip && pip completion --zsh >| "$completions_folder/_pip" && completions_array+=("pip")

# Procs
has_cmd procs && procs --gen-completion-out zsh >| "$completions_folder/_procs" && completions_array+=("procs")

# If register-python-argcomplete is available it can be used to create compdef for many python programs
if has_cmd register-python-argcomplete; then
  # Pipx
  has_cmd pipx && register-python-argcomplete pipx >| "$completions_folder/_pipx" && completions_array+=("pipx")
fi

# Rust & Cargo
if has_cmd rustup; then
  rustup completions zsh >| "$completions_folder/_rustup" && completions_array+=("rustup")
  has_cmd cargo && rustup completions zsh cargo >| "$completions_folder/_cargo" && completions_array+=("cargo")
fi

# Uv and uvx
has_cmd uv && uv generate-shell-completion zsh >| "$completions_folder/_uv" && completions_array+=("uv")
has_cmd uvx && uvx --generate-shell-completion zsh >| "$completions_folder/_uvx" && completions_array+=("uvx")

# yq
has_cmd yq && yq completion zsh >| "$completions_folder/_yq" && completions_array+=("yq")

info "Completions added: ${completions_array[*]}"