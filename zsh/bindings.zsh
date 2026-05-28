# Expand aliases
function glob-alias {
  zle _expand_alias
}
zle -N glob-alias

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/magic-enter
: ${MAGIC_ENTER_GIT_COMMAND:="git status -u ."} # run when in a git repository
: ${MAGIC_ENTER_DEFAULT_COMMAND:="ls -la ."}      # run anywhere else

(( $+functions[magic-enter-cmd] )) ||
function magic-enter-cmd {
  local cmd
  cmd="$MAGIC_ENTER_DEFAULT_COMMAND"

  if (( $+commands[git] )) && command git rev-parse --is-inside-work-tree &>/dev/null; then
    cmd="$MAGIC_ENTER_GIT_COMMAND"
  fi

  echo $cmd
}

function magic-enter {
  # Only run MAGIC_ENTER commands when in PS1 and command line is empty
  if [[ -n "$BUFFER" || "$CONTEXT" != start ]]; then
    return
  fi
  BUFFER=$(magic-enter-cmd)
}

# Wrapper for the accept-line zle widget (run when pressing Enter)
# If the wrapper already exists don't redefine it
if (( ! $+functions[_magic-enter_accept-line] )); then
  case "$widgets[accept-line]" in
    user:*) zle -N _magic-enter_orig_accept-line "${widgets[accept-line]#user:}"
      function _magic-enter_accept-line {
        magic-enter
        zle _magic-enter_orig_accept-line -- "$@"
      } ;;
    builtin) function _magic-enter_accept-line {
        magic-enter
        zle .accept-line
      } ;;
  esac
  zle -N accept-line _magic-enter_accept-line
fi

# Special case for Ctrl+Left, Alt+Left, Ctrl+Right and Alt+Right because they have multiple possible binds.
bind2maps emacs -- emacs-backward-word Ctrl+Left Alt+Left
bind2maps emacs -- emacs-forward-word Ctrl+Right Alt+Right
bind2maps viins vicmd -- vi-backward-word Ctrl+Left Alt+Left
bind2maps viins vicmd -- vi-forward-word Ctrl+Right Alt+Right

# Global keys bound to emacs, viins and vicmd
# bind2maps emacs viins vicmd -- beginning-of-line Home
bind2maps emacs viins vicmd -- end-of-line End
bind2maps emacs viins vicmd -- delete-char Delete

# emacs and vi insert mode keybinds
bind2maps emacs viins -- backward-delete-char Backspace
bind2maps emacs viins -- backward-kill-word Ctrl+W
bind2maps emacs viins -- kill-region Alt+W

# Expand aliases with ctrl-space
bind2maps emacs viins -- glob-alias Ctrl+Space
bind2maps emacs viins -- magic-space Space

# normal space during searches
bind2maps isearch -- magic-space Space

# Flatpak install/uninstall
if (( $+functions[flatpak-install] )); then
  zle -N flatpak-install
  bind2maps emacs -- flatpak-install Ctrl+Alt+I
fi
if (( $+functions[flatpak-uninstall] )); then
  zle -N flatpak-uninstall
  bind2maps emacs -- flatpak-uninstall Ctrl+Alt+U
fi
