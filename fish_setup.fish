#! /usr/bin/env fish

# BREW -----

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/config/fish/config.fish && echo -e "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/config/fish/config.fish

# OH MY FISH -----

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf --noninteractive
omf install agnoster
omf theme agnoster

# FISHER -----

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# FISH CONFIG -----

alias ls="exa --icons"
alias cat="bat"

# NVM -----

fisher install jorgebucaran/nvm.fish
echo "nvm use 16 &> /dev/null"  >> $HOME/.config/fish/config.fish

# LVIM PATH -----

fish_add_path ~/.local/bin/
fish_add_path ~/.local/share/nvm/v16.17.0/bin/node
