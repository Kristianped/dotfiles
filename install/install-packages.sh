#!/usr/bin/env bash

set -o errexit

source "$DOTFILES/bootstrap"
source "$DOTFILES/install_config"
source /etc/os-release

OS_DISTRO=$ID
OS_DISTRO_LIKE=${ID_LIKE:-$ID}
OS_DISTRO_ORIGINAL=$OS_DISTRO
OS_VERSION=${BUILD_ID:-${VERSION_ID:-VERSION_CODENAME}}

if [[ $OS_DISTRO_LIKE =~ (ubuntu|debian) ]]; then
  OS_DISTRO="debian"
fi

_install_arch() {
  local pacman_conf pacman_custom_conf
  pacman_conf=/etc/pacman.conf
  pacman_custom_conf=/etc/pacman.d/01-options.conf

  # Disable multilib in /etc/pacman.conf
  if grep -q "^\[multilib\]" "$pacman_conf"; then
    sudo sed -i "/^\[multilib\]/,+1 s/^/#/" "$pacman_conf"
  fi

  # Symlink 01-options.conf
  sudo ln -sf "$DOTFILES/arch/01-options.conf" "$pacman_custom_conf"

  # Make sure 'include = /etc/pacman.d/*.conf' exists in pacman-config
  if ! grep -q "Include = /etc/pacman\.d/\*\.conf" "$pacman_conf"; then
    printf "\nInclude = /etc/pacman.d/*.conf\n" | sudo tee --append "$pacman_conf" 1>/dev/null
  fi

  # Install packages
  install_package -m=pacman -y "${PACKAGES_PACMAN[@]}"

  # Install Yay
  local yay_version_local yay_version_remote
  yay_version_local=$(yay --version 2>/dev/null | cut -d " " -f 2 || true)
  yay_version_remote=$(git ls-remote --tags https://github.com/Jguer/yay.git \
    | grep -Eo "v?[0-9]+(\.[0-9]+){1,2}$" | sort --version-sort | tail -n 1)

  if [[ "$yay_version_local" != "$yay_version_remote" ]]; then
    local yay_install_path
    yay_install_path=$XDG_DATA_HOME/yay-bin
    clone_or_pull "https://aur.archlinux.org/yay-bin.git" "$yay_install_path"
    do_action_in_dir "$yay_install_path" makepkg --syncdeps --install --noconfirm
  fi

  sudo ln -sf "/run/systemd/resolve/stub-resolv.conf" "/etc/resolv.conf"
}

_install_debian() {
  # Install packages
  install_package -m=apt -y "${PACKAGES_APT[@]}"
}

case $OS_DISTRO in
  arch) _install_arch ;;
  debian) _install_debian ;;
  *) warning "Distro not supported. '$OS_DISTRO_ORIGINAL' based on '$OS_DISTRO_LIKE'. Version: '$OS_VERSION'"
esac