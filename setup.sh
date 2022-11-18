#!/usr/bin/env bash

MAIN_DIR="$(pwd)"
NIX_FILES=("config.nix" "flake.nix" "home.nix")
REQUIRED_PROGRAMS=(wget git zip unzip gzip curl file build-essential procps csvkit)
APPS_TO_UNINSTALL=($(apt list --installed | grep libreoffice | cut -d "/" -f 1) (geary gnome-calendar gnome-contacts gnome-terminal evince))
PROGRAMS_FILE="$MAIN_DIR/aux_files/apt-flatpak-programs.csv"
APT_PROGRAMS=()
FLATPAK_PROGRAMS=()

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

for app in "${APPS_TO_INSTALL[@]}"; do
    sudo apt remove "$app" -y
done

sh <(curl -L https://nixos.org/nix/install) --daemon
echo 'export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS' >> "$HOME/.profile"
source "$HOME/.profile"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
echo 'export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}' >> "$HOME/.profile"
source "$HOME/.profile"
nix-shell '<home-manager>' -A install

sudo cp "$MAIN_DIR/aux_files/SauceCodePro.zip" "/usr/share/fonts"
sudo unzip "/usr/share/fonts/SauceCodePro.zip"
sudo fc-cache

for program in "${APT_PROGRAMS[@]}"; do
    sudo apt install "$program" -y
done

for program in "${FLATPAK_PROGRAMS[@]}"; do
    flatpak install "$program" -y
done

"$HOME.nix-profile/bin/micromamba"

      # let
      #   my-python-packages = python-packages: with python-packages; [
      #     pandas
      #     matplotlib
      #     numpy
      #     scipy
      #     scikit-learn
      #     pyarrow
      #     sympy
      #   ];
      #   python-with-my-packages = python310.withPackages my-python-packages;
      #   my-r-packages = rWrapper.override{
      #     packages = with rPackages;
      #       [
      #         ggplot2
      #         dplyr
      #         dbplyr
      #         dtplyr
      #         tidyr
      #         readr
      #         purrr
      #         tibble
      #         stringr
      #         forcats
      #         DBI
      #         glue
      #         data_table
      #         quarto
      #         janitor
      #         pbapply
      #         styler
      #         zoo
      #         xts
      #         lintr
      #         fs
      #         distill
      #         tinytex
      #         languageserver
      #         writexl
      #         devtools
      #         usethis
      #         assertthat
      #         testthat
      #       ];
      #   };
      # in [

stow --target="$HOME" --dir="$HOME"/Projects/bkps/ --stow .dotfiles

sudo cp "$HOME/Projects/bkps/aux_files/phrmendes" "/var/lib/AccountsService/users/"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.imgs/wallpaper.png"

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync

home-manager switch
