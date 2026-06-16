# Set Zsh editor options.
setopt NO_beep                 # Do not beep on error in line editor.
setopt NO_flow_control         # Allow the usage of ^Q/^S in the context of zsh.

# Delete all existing keymaps and reset to the default state.
bindkey -d
bindkey -e

# Mapping escape sequences

# If NumLock is off, translate keys to make them appear the same as with NumLock on.
bindkey -s '^[OM'     '^M'      # enter
bindkey -s '^[OX'     '='
bindkey -s '^[Oj'     '*'
bindkey -s '^[Ok'     '+'
bindkey -s '^[Om'     '-'
bindkey -s '^[Oo'     '/'

# If someone switches our terminal to application mode (smkx), translate keys to make
# them appear the same as in raw mode (rmkx).
bindkey -s '^[OA'     '^[[A'    # up
bindkey -s '^[OB'     '^[[B'    # down
bindkey -s '^[OD'     '^[[D'    # left
bindkey -s '^[OC'     '^[[C'    # right
bindkey -s '^[OH'     '^[[H'    # home
bindkey -s '^[OF'     '^[[F'    # end

# TTY sends different key codes. Translate them to regular.
bindkey -s '^[[1~'    '^[[H'    # home
bindkey -s '^[[4~'    '^[[F'    # end

# Urxvt sends different key codes. Translate them to regular.
bindkey -s '^[[7~'    '^[[H'    # home
bindkey -s '^[[8~'    '^[[F'    # end
bindkey -s '^[Oa'     '^[[1;5A' # ctrl+up
bindkey -s '^[Ob'     '^[[1;5B' # ctrl+down
bindkey -s '^[Od'     '^[[1;5D' # ctrl+left
bindkey -s '^[Oc'     '^[[1;5C' # ctrl+right
bindkey -s '^[[3\^'   '^[[3;5~' # ctrl+delete
bindkey -s '^[^[[A'   '^[[1;3A' # alt+up
bindkey -s '^[^[[B'   '^[[1;3B' # alt+down
bindkey -s '^[^[[D'   '^[[1;3D' # alt+left
bindkey -s '^[^[[C'   '^[[1;3C' # alt+right
bindkey -s '^[^[[7~'  '^[[1;3H' # alt+home
bindkey -s '^[^[[8~'  '^[[1;3F' # alt+end
bindkey -s '^[^[[3~'  '^[[3;3~' # alt+delete
bindkey -s '^[[a'     '^[[1;2A' # shift+up
bindkey -s '^[[b'     '^[[1;2B' # shift+down
bindkey -s '^[[d'     '^[[1;2D' # shift+left
bindkey -s '^[[c'     '^[[1;2C' # shift+right
bindkey -s '^[[7$'    '^[[1;2H' # shift+home
bindkey -s '^[[8$'    '^[[1;2F' # shift+end

typeset -gA key_map=(
  Tab                         '^I'
  Space                       ' '
  Enter                       '^M'
  Escape                      '^['
  Ctrl+Space                  '^ '
  Alt+Space                   '^[ '

  Up                          '^[[A'
  Down                        '^[[B'
  Right                       '^[[C'
  Left                        '^[[D'
  Home                        '^[[H'
  End                         '^[[F'
  Insert                      '^[[2~'
  Delete                      '^[[3~'
  PageUp                      '^[[5~'
  PageDown                    '^[[6~'
  Backspace                   '^?'

  Ctrl+Up                     '^[[1;5A'
  Ctrl+Down                   '^[[1;5B'
  Ctrl+Right                  '^[[1;5C'
  Ctrl+Left                   '^[[1;5D'
  Ctrl+Home                   '^[[1;5H'
  Ctrl+End                    '^[[1;5F'
  Ctrl+Insert                 '^[[2;5~'
  Ctrl+Delete                 '^[[3;5~'
  Ctrl+PageUp                 '^[[5;5~'
  Ctrl+PageDown               '^[[6;5~'
  Ctrl+Backspace              '^H'

  Shift+Up                    '^[[1;2A'
  Shift+Down                  '^[[1;2B'
  Shift+Right                 '^[[1;2C'
  Shift+Left                  '^[[1;2D'
  Shift+Home                  '^[[1;2H'
  Shift+End                   '^[[1;2F'
  Shift+Insert                '^[[2;2~'
  Shift+Delete                '^[[3;2~'
  Shift+PageUp                '^[[5;2~'
  Shift+PageDown              '^[[6;2~'
  Shift+Backspace             '^?'

  Alt+Up                      '^[[1;3A'
  Alt+Down                    '^[[1;3B'
  Alt+Right                   '^[[1;3C'
  Alt+Left                    '^[[1;3D'
  Alt+Home                    '^[[1;3H'
  Alt+End                     '^[[1;3F'
  Alt+Insert                  '^[[2;3~'
  Alt+Delete                  '^[[3;3~'
  Alt+PageUp                  '^[[5;3~'
  Alt+PageDown                '^[[6;3~'
  Alt+Backspace               '^[^?'
)

function bind2maps {
  local i widget kb seq
  local -a maps
  local -a seqs

  while [[ "$1" != "--" ]]; do
    maps+=( "$1" )
    shift
  done
  shift

  widget="$1"
  shift

  for kb in "$@"; do
    if [[ -n ${seq::=$key_map[$kb]} ]]; then
      seqs+=( "$seq" )
      shift
      continue
    fi

    case $kb in
      ?~[a-z])
        seq=${kb:l}
        seqs+=( "$seq" )
        shift
      ;;
      Ctrl+[A-Z])
        seq="^${kb[-1]:u}"
        seqs+=( "$seq" )
        shift
      ;;
      Alt+[A-Z])
        seq="^[${kb[-1]:l}"
        seqs+=( "$seq" )
        shift
      ;;
      Ctrl+Alt+[A-Z])
        seq="^[^${kb[-1]:u}"
        seqs+=( "$seq" )
        shift
      ;;
      *)
        print -Pru2 -- '%F{3}z4h%f: invalid key binding: %F{1}'${kb//\%/%%}'%f'
        return 1
      ;;
    esac
  done

  for i in "${maps[@]}"; do
    for seq in "${seqs[@]}"; do
      bindkey -M "$i" "$seq" "$widget"
    done
  done
}
