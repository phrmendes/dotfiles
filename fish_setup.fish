#! /usr/bin/env fish

##############################################################
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ #
# ██░▄▄▄█▄░▄██░▄▄▄░██░██░████░▄▄▄░██░▄▄▄█▄▄░▄▄██░██░██░▄▄░██ #
# ██░▄▄███░███▄▄▄▀▀██░▄▄░████▄▄▄▀▀██░▄▄▄███░████░██░██░▀▀░██ #
# ██░████▀░▀██░▀▀▀░██░██░████░▀▀▀░██░▀▀▀███░████▄▀▀▄██░█████ #
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ #
##############################################################

# OH MY FISH ---------

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fish install --path=~/.local/share/omf --config=~/.config/omf --yes
omf install agnoster
omf theme agnoster

# FISHER ---------

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# FISH CONFIG ---------

echo 'alias ls="exa --icons"' >>~/.config/fish/config.fish
echo 'alias cat="bat"' >>~/.config/fish/config.fish
echo 'alias radian="$HOME/mambaforge/bin/radian"' >>~/.config/fish/config.fish
echo 'alias r="$HOME/mambaforge/bin/radian"' >>~/.config/fish/config.fish

# NIX ---------

fisher install lilyball/nix-env.fish

# LVIM PATH ---------

fish_add_path ~/.local/bin/
fish_add_path ~/.emacs.d/bin
