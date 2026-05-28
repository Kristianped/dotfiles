#!/usr/bin/env zsh

# Set the name of the static .zsh plugins file antidote will generate.
static_file=$ZDOTDIR/zsh_plugins

# The plugins-file where plugins are added
bundle_file=$DOTFILES/zsh/antidote_plugins.txt

# If antidote-directory does not exist, clone from github
[[ -d $ANTIDOTE_DIR ]] || clone_or_pull "mattmc3/antidote" "$ANTIDOTE_DIR"

# Source Antidote.
source $ANTIDOTE_DIR/antidote.zsh

# Use friendly names with the bundle directory in $ANTIDOTE_HOME.
zstyle ':antidote:bundle' use-friendly-names    on
# Set custom bundle file. Default: ${ZDOTDIR:-$HOME}/.zsh_plugins
zstyle ':antidote:bundle' file                  $bundle_file
# Set custom static file. Default: ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
zstyle ':antidote:static' file                  $static_file
# Zsh compile everything, static file and all bundles.
zstyle ':antidote:*'      zcompile              yes


#
# Plugin settings: Set options for various plugins.
#

# Zephyr config
zstyle ':zephyr:plugin:*'           use-xdg-basedirs yes
zstyle ':zephyr:plugin:history'    'histfile'        $HISTFILE
zstyle ':zephyr:plugin:completion' 'use-cache' 'yes'

# eza config
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header'     yes
zstyle ':omz:plugins:eza' 'icons'      yes

# fzf-tab
export FZF_TMUX_HEIGHT=90%
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:tree:*' fzf-preview 'eza -1 --tree --color=always $realpath'


# Initialize plugins statically with ${ZDOTDIR:-$HOME/.config/zsh}/zsh_plugins file.
# Note: Must be loaded after setting zstyles.
antidote load
