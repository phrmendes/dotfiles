#! ~/.nix-profile/bin/fish

##############################################################
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ #
# ██░▄▄▄█▄░▄██░▄▄▄░██░██░████░▄▄▄░██░▄▄▄█▄▄░▄▄██░██░██░▄▄░██ #
# ██░▄▄███░███▄▄▄▀▀██░▄▄░████▄▄▄▀▀██░▄▄▄███░████░██░██░▀▀░██ #
# ██░████▀░▀██░▀▀▀░██░██░████░▀▀▀░██░▀▀▀███░████▄▀▀▄██░█████ #
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ #
##############################################################

# FISHER ---------

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# FISH CONFIG ---------

echo 'alias ls="exa --icons"' >"$HOME"/.config/fish/config.fish
echo 'alias cat="bat"' >>"$HOME"/.config/fish/config.fish
echo 'alias stow_dotfiles="stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles"' >>"$HOME"/.config/fish/config.fish

# NIX ---------

fisher install lilyball/nix-env.fish

# STARSHIP ---------

echo 'starship init fish | source' >>"$HOME"/.config/fish/config.fish

# PATHS ---------

fish_add_path ~/.local/bin/
fish_add_path ~/.emacs.d/bin

# ENV VARIABLES ---------

echo 'set -gx STARSHIP_CONFIG "$HOME"/.config/starship/starship.toml' >>"$HOME"/.config/fish/config.fish
