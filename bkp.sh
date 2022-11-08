#!/usr/bin/env bash

###############################################################################
## ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ##
## ██░▄▄▀█░▄▄▀██░▄▄▀██░█▀▄██░██░██░▄▄░████░▄▄▄░██░▄▄▀██░▄▄▀█▄░▄██░▄▄░█▄▄░▄▄█ ##
## ██░▄▄▀█░▀▀░██░█████░▄▀███░██░██░▀▀░████▄▄▄▀▀██░█████░▀▀▄██░███░▀▀░███░███ ##
## ██░▀▀░█░██░██░▀▀▄██░██░██▄▀▀▄██░███████░▀▀▀░██░▀▀▄██░██░█▀░▀██░██████░███ ##
## ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ##
###############################################################################

# VARIABLES ---------

BLUE="\e[1;34m"
GREEN="\e[1;32m"
NO_COLOR="\e[0m"
MAIN_DIR="$(pwd)"

# READING FILES ---------

reading_programs_file () {
    PROGRAMS_APT=()
    PROGRAMS_FLATPAK=()
    local file_apps="/tmp/apps.txt"

    if [[ $pc_or_laptop == "pc" ]]; then
        csvsql --query "select program,package_manager from programs" "$MAIN_DIR"/programs.csv | tail -n +2 | xargs echo | tr ' ' '\n' > "$file_apps" 
    else
        csvsql --query "select program,package_manager from programs where where_install='both'" "$MAIN_DIR"/programs.csv | tail -n +2 | xargs echo | tr ' ' '\n' > "$file_apps"
    fi

    while IFS= read -r line; do
        local str_1
        local str_2

        str_1=$(echo -e "${line%%,*}")
        str_2=$(echo -e "${line##*,}")

        if [[ $str_2 = "apt" ]]; then
            PROGRAMS_APT+=("$str_1")
        else
            PROGRAMS_FLATPAK+=("$str_1")
        fi
    done < "$file_apps"
}

# INSTALLING PROGRAMS ---------

install_flatpak () {
    for program in "${PROGRAMS_FLATPAK[@]}"; do
        echo -e "${BLUE}[IN PROGRESS] - Installing $program (flatpak)...${NO_COLOR}"
        flatpak install "$program" -y 
        echo -e "${GREEN}[DONE] - $program installed.${NO_COLOR}"
    done
}

setup_fonts () {
    echo -e "${BLUE}[IN PROGRESS] - Setting up fonts...${NO_COLOR}"
    mkdir -p "$HOME"/.local/share/fonts/NerdFonts
    unzip -d "/tmp/NerdFonts" "$MAIN_DIR/NerdFonts.zip"
    cp -r /tmp/NerdFonts/* "$HOME/.local/share/fonts/NerdFonts"
    fc-cache -f -v "$HOME"/.local/share/fonts/
    echo -e "${GREEN}[DONE] - Fonts set up.${NO_COLOR}"
}

setup_fish () {
    echo -e "${BLUE}[IN PROGRESS] - Setting up fish...${NO_COLOR}"
    chmod +x "$MAIN_DIR/setup.fish"
    "$HOME/.nix-profile/bin/fish" "$MAIN_DIR/setup.fish"
    sudo ln -s "$(which fish)" /usr/bin/fish
    echo -e "${GREEN}[DONE] - Fish set up.${NO_COLOR}"
}

setup_emacs () {
    echo -e "${BLUE}[IN PROGRESS] - Setting up Emacs...${NO_COLOR}"
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
    "$HOME/.emacs.d/bin/doom" install
    "$HOME/.emacs.d/bin/doom" sync
    echo -e "${GREEN}[DONE] - Emacs set up.${NO_COLOR}"
}

stow_dotfiles () {
    echo -e "${BLUE}[IN PROGRESS] - Setting up dotfiles...${NO_COLOR}"
    stow --target="$HOME" --dir="$HOME"/Projects/bkps/ --stow .dotfiles
    echo -e "${GREEN}[DONE] - Dotfiles set up.${NO_COLOR}"
}

# EXECUTION ---------

read -r -p "PC or laptop? (pc/lp): " pc_or_laptop

reading_programs_file
install_flatpak
setup_fonts
setup_emacs
setup_fish

echo -e "${GREEN}[DONE] - Setup finished.${NO_COLOR}"
