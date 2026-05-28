#!/usr/bin/env zsh

# Search and find directories in the dir stack
fpop() {
  dirs -v \
    | fzf \
      --query="$1" \
      --ansi \
      --header="Press ENTER to go to selected directory" \
      --preview 'path={2}; path="${path/#\~/$HOME}"; /bin/ls -la $path' \
    | cut -f 1 | source /dev/stdin
}

# cdf - cd into the directory of the selected file
fcd() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# List install files for dotfiles
fdot() {
  fexec "$DOTFILES/install"
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
      --bind="ctrl-r:reload(date; ps -u "$USER" -o pid:12,comm:20,euser:20)" \
      --bind="enter:execute(kill -9 {1})+reload(date; ps -u "$USER" -o pid:12,comm:20,euser:20)"
}

# Search through all man pages
fman() {
  man -k . | sort | uniq \
    | fzf \
      --query="$1" \
      --ansi \
      --prompt=" Man > " \
      --header="Press enter to view" \
      --preview="echo {} | awk '{print $1}' | xargs -r batman" \
      --bind="enter:become(echo {} | awk '{print \$1}' | xargs -r man)"
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
    --bind "enter:become(flatpak run org.kde.kate -l {2} {1})"
}
