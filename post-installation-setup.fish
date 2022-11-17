# flathub and flatpak apps
for program in a b c
    flatpak install "$program" -y
end

# doom emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync
fish_add_path "$HOME/.emacs.d/bin"
ln -s "$(pwd)/.doom.d" "$HOME"/
