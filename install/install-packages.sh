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

case $OS_DISTRO in
  debian) install_package -m=apt "${PACKAGES_APT[@]}" ;;
  *) warning "Distro not supported. '$OS_DISTRO_ORIGINAL' based on '$OS_DISTRO_LIKE'. Version: '$OS_VERSION'"
esac