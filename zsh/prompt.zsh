#!/usr/bin/env zsh

setopt prompt_subst       # Expand parameters in prompt variables.

zsh_prompt=${ZSH_PROMPT:-pure}

function prompt_p10k_setup {
  prompt_powerlevel10k_setup

  local p10k_config config_file
  p10k_config=${ZSH_PROMPT_CONFIG:-pure}
  config_file=$ZSH_PROMPT_CONFIG_PATH/p10k/$p10k_config.p10k.zsh

  if [[ -f $config_file ]]; then
    source "$config_file"
  else
    source "$ZSH_PROMPT_CONFIG_PATH/p10k/pure.p10k.zsh"
  fi
}

# Starship is installed as a single script-file, we add this function to work with zsh's prompt system
function prompt_starship_setup {
  local starship_config config_file
  starship_config=${ZSH_PROMPT_CONFIG:-pure}
  config_file=$ZSH_PROMPT_CONFIG_PATH/starship/$starship_config.toml

  if [[ -f $config_file ]]; then
    export STARSHIP_CONFIG=$config_file
  else
    export STARSHIP_CONFIG=$ZSH_PROMPT_CONFIG_PATH/starship/pure.toml
  fi

  eval "$(starship init zsh)"
}

load_p10k() {
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  zstyle ':zephyr:plugin:prompt' 'theme' 'powerlevel10k'
}

function run_promptinit {
  # Initialize the prompt system.
  autoload -Uz promptinit && promptinit

  if (( $+functions[prompt_powerlevel10k_setup] )); then
    prompt_themes+=( p10k )
  else
    unfunction prompt_p10k_setup
  fi

  if (( $+commands[starship] )); then
    prompt_themes+=( starship )
  else
    unfunction prompt_starship_setup
  fi

  # Keep prompt array sorted.
  prompt_themes=( "${(@on)prompt_themes}" )

  # Set the prompt
  if [[ $TERM == (dumb|linux|*bsd*) ]]; then
    prompt 'off'
  else
    prompt "$zsh_prompt"
  fi
}

# Enable Powerlevel10k instant prompt
if [[ $zsh_prompt == "p10k" ]]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi