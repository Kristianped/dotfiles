#!/usr/bin/env zsh

# Colors
# ---------------
if [ -s "$FZF_CONFIG_PATH/theme.sh" ]; then
  source "$FZF_CONFIG_PATH/theme.sh"
else
  export FZF_COLOR_SCHEME="\
  --color=fg:gray,hl:yellow \
  --color=fg+:white,bg+:-1,hl+:red \
  --color=info:green,prompt:gray,pointer:red \
  --color=marker:blue,spinner:black,header:blue"
fi


# fd is faster than rg, rg is faster than find
# Show hidden, and exclude .git and the pigsty node_modules files
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

  _fzf_compgen_dir() {
    eval "$FZF_ALT_C_COMMAND . \"$1\""
  }

  _fzf_compgen_path() {
    eval "$FZF_DEFAULT_COMMAND . \"$1\""
  }
else
  export FZF_ALT_C_COMMAND='find . -type d ( -path .git -o -path node_modules ) -prune'

  if (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}/**"'
  else
    export FZF_DEFAULT_COMMAND='find . -type f -not \( -path "*/.git/*" -o -path "./node_modules/*" \)'
  fi
fi


[[ -d "$FZF_CACHE_PATH" ]] || mkdir -p "$FZF_CACHE_PATH"

export FZF_DEFAULT_OPTS="--history=$FZF_CACHE_PATH/fzf_history.txt
  --height 80%
  --multi
  --layout reverse
  $FZF_COLOR_SCHEME
  --prompt '❯ '
  --pointer ❯
  --marker ✓
  --preview 'bat --color=always --highlight-line={2} {1} 2> /dev/null || less {1}'
  --bind 'tab:down'
  --bind 'btab:up'
  --bind 'ctrl-j:jump'
  --bind 'ctrl-k:kill-line'
  --bind 'ctrl-p:previous-history'
  --bind 'ctrl-n:next-history'
  --bind 'ctrl-q:clear-query'
  --bind 'ctrl-space:toggle'
  --bind 'ctrl-x:toggle-preview'
  --bind 'ctrl-w:preview-up'
  --bind 'ctrl-s:preview-down'
  --bind 'ctrl-a:preview-page-up'
  --bind 'ctrl-d:preview-page-down'
  --bind 'ctrl-e:change-preview-window(bottom|right)'
  --bind 'ctrl-r:change-preview-window(50%|hidden|)'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# Key bindings
# ------------
if [[ -f "$FZF_PATH/shell/key-bindings.zsh" ]]; then
  source "$FZF_PATH/shell/key-bindings.zsh"
fi

# Rebind ALT-c to CTRL-e
# ---------------
bindkey -rM emacs '\ec'
bindkey -rM viins '\ec'
bindkey -rM vicmd '\ec'

zle -N fzf-cd-widget
bind2maps emacs viins vicmd -- fzf-cd-widget Ctrl+E


# Auto-completion
# ---------------
if [[ -f "$FZF_PATH/shell/completion.zsh" ]]; then
  source "$FZF_PATH/shell/completion.zsh"
fi

# Fzf scripts
# ------------
if [[ -f "$DOTFILES/fzf/fzf_scripts.zsh" ]]; then
  source "$DOTFILES/fzf/fzf_scripts.zsh"
fi

# Fzf-git
# ------------
if [[ -f "$FZF_GIT_PATH/fzf-git.sh" ]]; then
  source "$FZF_GIT_PATH/fzf-git.sh"
fi
