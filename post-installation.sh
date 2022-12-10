#!/usr/bin/env bash
FLATPAK_PROGRAMS=("com.github.muriloventuroso.easyssh" "com.mattjakeman.extensionmanager" "com.stremio.stremio" "com.github.tchx84.flatseal" "com.tutanota.tutanota" "eu.ithz.umftpd" "org.onlyoffice.desktopeditors" "org.gnome.Boxes")
MAIN_DIR="$(pwd)"
FONTS_DIR="$HOME/.local/share/fonts/"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

for program in "$FLATPAK_PROGRAMS"; do
    flatpak install "$program" -y
done

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync

stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles
