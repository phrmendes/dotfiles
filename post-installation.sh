#!/usr/bin/env bash
FLATPAK_PROGRAMS=("com.github.muriloventuroso.easyssh" "com.mattjakeman.extensionmanager" "com.stremio.stremio" "com.github.tchx84.flatseal" "com.tutanota.tutanota" "eu.ithz.umftpd" "org.onlyoffice.desktopeditors" "org.gnome.Boxes")
MAIN_DIR="$(pwd)"
FONTS_DIR="$HOME/.local/share/fonts/"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for program in "$FLATPAK_PROGRAMS"; do
    flatpak install "$program" -y
done

mkdir -p "$FONTS_DIR"
cp "$MAIN_DIR/aux_files/SauceCodePro.zip" "$FONTS_DIR"
cd "$FONTS_DIR"
unzip SauceCodePro.zip
rm SauceCodePro.zip
fc-cache -f -v
cd "$MAIN_DIR"

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync

stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles
