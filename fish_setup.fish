#! /usr/bin/env fish

# BREW -----

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r "$HOME/.config/fish/config.fish" && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.config/fish/config.fish"

# OH MY FISH -----

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fish install --path=~/.local/share/omf --config=~/.config/omf --yes
omf install agnoster
omf theme agnoster

# FISHER -----

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# FISH CONFIG -----

echo 'alias ls="exa --icons"' >> ~/.config/fish/config.fish
echo 'alias cat="bat"' >> ~/.config/fish/config.fish
echo 'alias radian="/home/$USER/mambaforge/bin/radian"' >> ~/.config/fish/config.fish
echo 'alias r="/home/$USER/mambaforge/bin/radian"' >> ~/.config/fish/config.fish

# NVM -----

fisher install jorgebucaran/nvm.fish
echo 'nvm use 16 &> /dev/null'  >> "$HOME/.config/fish/config.fish"

# LVIM PATH -----

fish_add_path ~/.local/bin/
fish_add_path ~/.local/share/nvm/v16.17.0/bin/node
