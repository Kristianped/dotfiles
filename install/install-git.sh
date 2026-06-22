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
  [[ -n "$GIT_EMAIL" ]] && return 0

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

_ask_for_name
_ask_for_email
git_config_local=$XDG_CONFIG_HOME/git/config.local

if [[ ! -f $git_config_local ]]; then
  cat <<EOF > "$git_config_local"
[user]
  name = "$GIT_USER"
  email = "$GIT_EMAIL"

# Uncomment the options below to auto-sign your git commits / tags using GPG.
#[commit]
#  gpgsign = true

# This option requires git 2.23+ to work and you must annotate your tags,
# although -m "" works if you want an empty message.
#[tag]
#  gpgSign = true

EOF
fi

# ssh key
ssh_key_path=$HOME/.ssh/id_ed25519
if [[ ! -f $ssh_key_path ]]; then
  mes_color "$YELLOW" "Create ssh key for '$GIT_EMAIL'?"
  if prompt_ask; then
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -N "" -f "$ssh_key_path"
  fi
fi
cat "$ssh_key_path.pub"

# gpg key for signing
if [[ ! "$(gpg --export --armor "$GIT_EMAIL" 2>/dev/null)" =~ "PGP PUBLIC KEY" ]]; then
  gpg_home=${GNUPGHOME:-$XDG_DATA_HOME/gnupg}
  mkdir -p "$gpg_home"
  chmod 0700 "$gpg_home"

  mes_color "$YELLOW" "Create gpg key for '$GIT_USER' and '$GIT_EMAIL'?"
  if prompt_ask; then
    while true; do
      mes_color "$GREEN" "Please set a passphrase (password) for your gpg key: "
      read -sr passphrase

      if [[ ! $passphrase =~ [^[:space:]]+ ]]; then
        error "Please enter at least 1 non-space character"
        continue
      fi

      mes_color "$GREEN" "Please confirm your passphrase: "
      read -sr passphrase_confirm
      if [ "$passphrase" = "$passphrase_confirm" ]; then
        info "Passphrases match"
        break
      fi

      error "The passphrases did not match"
    done

    gpg --batch --gen-key <<EOF
     Key-Type: 1
     Key-Length: 3072
     Subkey-Type: 1
     Subkey-Length: 3072
     Name-Real: $GIT_USER
     Name-Email: $GIT_EMAIL
     Passphrase: $passphrase
     Expire-Date: 1y
EOF
  fi
fi

gpg --list-keys "$GIT_EMAIL" | sed '$d'