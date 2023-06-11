#!/bin/bash

export PYENV_ROOT="$HOME/.pyenv"
export WEZTERM_CONFIG_FILE="$HOME/.wezterm.lua"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
path+=("$HOME/.local/bin")
