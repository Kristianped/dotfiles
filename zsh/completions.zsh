#!/usr/bin/env zsh

# Load more completions
fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src

# Should be called before compinit
zmodload zsh/complist

autoload -U compinit && compinit

# Register completions for pipx
[[ "$(command -v register-python-argcomplete)" && "$(command -v pipx)" ]] && eval "$(register-python-argcomplete pipx)"
