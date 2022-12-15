#!/usr/bin/env bash
FLATPAK_PROGRAMS=("com.github.muriloventuroso.easyssh" "com.mattjakeman.extensionmanager" "com.stremio.stremio" "com.github.tchx84.flatseal" "com.tutanota.tutanota" "eu.ithz.umftpd" "org.onlyoffice.desktopeditors" "org.gnome.Boxes")
MAIN_DIR="$(pwd)"
FONTS_DIR="$HOME/.local/share/fonts/"

sudo rm -r /etc/nixos/configuration.nix
sudo rm -r /etc/nixos/home.nix
sudo ln -s "$MAIN_DIR/configuration.nix" "/etc/nixos/"
sudo ln -s "$MAIN_DIR/home.nix" "/etc/nixos/"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

for program in "$FLATPAK_PROGRAMS"; do
    flatpak install "$program" -y
done

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync

sudo cat <<'EOF' > /usr/local/bin/plasma-i3.sh
#!/bin/sh
export KDEWM=$(which i3)
/usr/bin/startkde
EOF

sudo cat <<'EOF' > /usr/share/xsessions/plasma-i3.desktop
[Desktop Entry]
Type=XSession
Exec=/usr/local/bin/plasma-i3.sh
DesktopNames=KDE
Name=Plasma (i3)
Comment=Plasma by KDE w/i3
EOF

stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles
