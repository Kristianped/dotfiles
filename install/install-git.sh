#!/usr/bin/env bash

source "$DOTFILES/bootstrap"

mkdir -p "$XDG_CONFIG_HOME/git"

ln -sf "$DOTFILES/git/gitconfig" "$XDG_CONFIG_HOME/git/config"
ln -sf "$DOTFILES/git/gitignore" "$XDG_CONFIG_HOME/git/ignore"
ln -sf "$DOTFILES/git/gitattributes" "$XDG_CONFIG_HOME/git/attributes"

_ask_for_name() {
  [[ -n "$GIT_USER" ]] && return 0

  local name
  if name=$(git config user.name); then
    info "Name retrieved from git config"
  else
    while true; do
      printf "What is your full name (ie. Dade Murphy)? "
      read -r name

      if [[ ${name} =~ [^[:space:]]+ ]]; then
        break
      else
        warning_severe "Please enter at least your first name"
      fi
    done
  fi

  GIT_USER="$name"
}

_ask_for_email() {
  [[ -n "GIT_EMAIL" ]] && return 0

  local email=
  if email=$(git config user.email); then
    info "Email retrieved from git config"
  else
    while true; do
      printf "What is your email address (ie. zerocool@example.com)? "
      read -r email

      if [[ $email =~ .+@.+ ]]; then
        break
      else
        warning_severe "Please enter a valid email address"
      fi
    done
  fi

  GIT_EMAIL="$email"
}

if [[   ]]

