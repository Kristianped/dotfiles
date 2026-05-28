#!/usr/bin/env zsh

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# The substring separated with colons : are called components
## <completion>  - String acting as a namespace, to avoid pattern collisions with other scripts also using zstyle.
## <function>    - Apply the style to the completion of an external function or widget.
## <completer>   - Apply the style to a specific completer. We need to drop the underscore from the completer’s name here.
## <command>     - Apply the style to a specific command, like cd, rm, or sed for example.
## <argument>    - Apply the style to the nth option or the nth argument. It’s not available for many styles.
## <tag>         - Apply the style to a specific tag.

## For kubernetes
zstyle ':completion:*:*:kubectl:*' list-grouped false

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Group format
zstyle ':completion:*' format '[%d]'


# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
#zstyle ':completion:*' menu no

zstyle ':fzf-tab:complete:man:*' fzf-preview 'echo $word'

# Maven options
zstyle ':completion:*:mvn:*' show-all-phases true
zstyle ':completion:*:mvn:*' show-full-form-plugins true
