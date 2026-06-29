#!/usr/bin/env zsh

# Search and find directories in the dir stack
fpop() {
  eza_options="-la --no-time --no-filesize --no-permissions --no-user --group-directories-first --color=always --icons=auto"
  dirs -v | fzf \
    --query="$1" \
    --ansi \
    --header="Press ENTER to go to selected directory" \
    --preview "echo {2} | expand_tilde | xargs -r eza $eza_options" \
  | cut -f 1 | source /dev/stdin
}

# cdf - cd into the directory of the selected file
fcd() {
  local file
  local dir

  file=$(fzf +m -q "$1")
  dir=$(dirname "$file")
  cd "$dir" || return 1
}

fexec() {
  local dir="${1:-$PWD}"

  if [[ ! -d $dir ]]; then
    printf "%b%s%b\n" "\033[0;31m" "'$dir' is not a directory" "\033[0m"
    return 1
  fi

  fd --color=always --follow -t x . "$dir" | fzf \
    --ansi \
    --delimiter : \
    --header="Press enter to execute" \
    --preview "bat --color=always {}" \
    --bind "enter:become(echo \"Executing file: {}\"; {})"
}

# List install files for dotfiles
fdoti() {
  fexec "$DOTFILES/install"
}

# List update files for dotfiles
fdotu() {
  fexec "$DOTFILES/update"
}

# Kill process
fkill() {
  (date; ps -u "$USER" -o pid:12,comm:20,euser:20) | \
    fzf \
      --query="$1" \
      --ansi \
      --multi \
      --layout=reverse \
      --header="Press CTRL-R to reload and ENTER to kill a process" \
      --header-lines=2 \
      --preview="ps q {1} lww " \
      --bind="ctrl-r:reload(date; ps -u $USER -o pid:12,comm:20,euser:20)" \
      --bind="enter:execute(kill -9 {1})+reload(date; ps -u $USER -o pid:12,comm:20,euser:20)"
}

# Search through all man pages
fman() {
  manpage="echo {} | awk '{print \$1}'"
  batman="${manpage} | xargs -r man | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
  man -k . | sort \
   | awk -v cyan="$(tput setaf 6)" -v blue="$(tput setaf 4)" -v bold="$(tput bold)" -v reset="$(tput sgr0)" \
    '{
       info="";
       for(i=2;i<=NF;i++) {
         info=cyan info" "$i
       }
       print blue bold $1" -" reset info
    }' \
   | fzf  \
      --query "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > '  \
      --preview "${batman}" \
      --bind "enter:become(${manpage} | xargs -r man)"
}

# Search for text in files using Ripgrep
fif() {
  local RG_PREFIX INITIAL_QUERY
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case --hidden --follow "
  INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q} || true" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview "bat --color=always {1} --highlight-line {2}" \
    --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
    --bind "enter:become(nvim {1} +{2})"
}
