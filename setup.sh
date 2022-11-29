#!/usr/bin/env bash

MAIN_DIR="$(pwd)"
REQUIRED_PROGRAMS=(wget git zip unzip gzip curl file build-essential procps clang)
PROGRAMS_FILE="$MAIN_DIR/aux_files/apt-flatpak-programs.csv"
APT_PROGRAMS=()
FLATPAK_PROGRAMS=()

sudo apt update -y
sudo apt full-upgrade -y

while IFS= read line; do
    str_1=$(echo -e "${line%%,*}")
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

sh <(curl -L https://nixos.org/nix/install)
echo 'export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS' >> "$HOME/.profile"
source "$HOME/.profile"

for program in "${APT_PROGRAMS[@]}"; do
    sudo apt install "$program" -y
done
