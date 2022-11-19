#!/usr/bin/env bash

MAIN_DIR="$(pwd)"
REQUIRED_PROGRAMS=(wget git zip unzip gzip curl file build-essential procps)
TO_REMOVE=(geary gnome-terminal gnome-orca evince totem xterm)
PROGRAMS_FILE="$MAIN_DIR/aux_files/apt-flatpak-programs.csv"
APT_PROGRAMS=()
FLATPAK_PROGRAMS=()

sudo apt update -y
sudo apt full-upgrade -y

while IFS= read line; do
    str_1=$(echo -e "${line%%,*}")
sudo apt dist-upgrade -y
    str_2=$(echo -e "${line##*,}")

    if [[ $str_2 = "apt" ]]; then
        APT_PROGRAMS+=("$str_1")
    else
        FLATPAK_PROGRAMS+=("$str_1")
    fi
done < "$PROGRAMS_FILE"

for app in "${REQUIRED_PROGRAMS[@]}"; do
    if [[ ! -x $(which "$app") ]]; then
        sudo apt install "$app" -y
    fi
done

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo dpkg --add-architecture i386

apt list --installed | grep libreoffice | cut -d "/" -f 1 | tr '\n' ' ' | xargs sudo apt remove -y

for program in "${TO_REMOVE@]}"; do
    sudo apt remove "$program" -y
done

sudo apt autoremove -y

sh <(curl -L https://nixos.org/nix/install) --daemon
echo 'export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS' >> "$HOME/.profile"
source "$HOME/.profile"

sudo mkdir -p "/usr/share/fonts/truetype/sourcecodepro/"
sudo cp "$MAIN_DIR/aux_files/SauceCodePro.zip" "/usr/share/fonts/truetype/sourcecodepro/"
sudo cd "/usr/share/fonts/truetype/sourcecodepro/"
sudo unzip SauceCodePro.zip
sudo rm SauceCodePro.zip
sudo fc-cache
cd "$MAIN_DIR"

for program in "${APT_PROGRAMS[@]}"; do
    sudo apt install "$program" -y
done

for program in "${FLATPAK_PROGRAMS[@]}"; do
    flatpak install "$program" -y
done

sudo cp "$MAIN_DIR/aux_files/phrmendes" "/var/lib/AccountsService/users/"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.imgs/wallpaper.png"
gsettings set org.gnome.desktop.interface enable-animations false
