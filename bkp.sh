#!/usr/bin/env bash

############################### variables #####################################

DEB_URLS_FILE="deb_urls.txt"
PROGRAMS_FILE="programs.txt"
DIR_DOWNLOAD="$HOME/Downloads/deb_packages"
PPAS_URLS_FILE="ppas.txt"
TUTANOTA_LINK="https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage"
RED="\e[1;31m"
BLUE="\e[1;34m"
GREEN="\e[1;32m"
NO_COLOR="\e[0m"

############################### pre-installation ##############################

requirements () {
    local apps 
    
    apps=(wget git zip unzip gzip curl flatpak)

    for app in "${apps[@]}"; do
        if [[ ! -x $(which "$app") ]]; then
            echo -e "${RED}[ERROR] - $app not installed.${NO_COLOR}"
            echo -e "${BLUE}[IN PROGRESS] - Installing $app...${NO_COLOR}"

            sudo apt install "$app" -y &> "/dev/null"

            echo -e "${GREEN}[DONE] - $app installed."
        else
            echo -e "${GREEN}[DONE] - $app already installed."
        fi
    done
}

remove_locks () {
    echo -e "${BLUE}[IN PROGRESS] - Removing locks...${NO_COLOR}"
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
    echo -e "${GREEN}[DONE] - Locks removed.${NO_COLOR}"
}

add_i386_architecture () {
    echo -e "${BLUE}[IN PROGRESS] - Adding x86 architecture...${NO_COLOR}"
    sudo dpkg --add-architecture i386
    echo -e "${GREEN}[DONE] - x86 architecture added.${NO_COLOR}"
}

setup_nix () {
    echo -e "${BLUE}[IN PROGRESS] - Installing Nix...${NO_COLOR}"
    sudo mkdir /nix
    sudo chown -R "$USER" /nix
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    echo -e "${GREEN}[DONE] - Nix installed.${NO_COLOR}"
}

setup_fish() {
    chmod +x setup.fish
    fish setup.fish
}

remove_installed () {
    local libreoffice
    local apps

    libreoffice=$(apt list --installed | grep libreoffice | cut -d "/" -f 1)
    apps=(geary gnome-calendar gnome-contacts)

    for app in "${apps[@]}"; do
        echo -e "${BLUE}[IN PROGRESS] - Removing $app...${NO_COLOR}"
        sudo apt remove "$app" -y
        echo -e "${GREEN}[DONE] - $app removed.${NO_COLOR}"
    done
    
    for app in $libreoffice; do
        echo -e "${BLUE}[IN PROGRESS] - Removing $app...${NO_COLOR}"
        sudo apt remove "$app" -y
        echo -e "${GREEN}[DONE] - $app removed.${NO_COLOR}"
    done
    }

setup_docker () {
    echo -e "${BLUE}[IN PROGRESS] - Installing Docker...${NO_COLOR}"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    att_repos
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo groupadd docker
    sudo usermod -aG docker "USER"
    echo -e "${GREEN}[DONE] - Docker installed.${NO_COLOR}"
}

setup_fonts () {
    echo -e "${BLUE}[IN PROGRESS] - Setting up fonts...${NO_COLOR}"
    mkdir -p "$HOME"/.local/share/fonts/NerdFonts
    unzip NerdFonts.zip
    cp -r NerdFonts/* "$HOME"/.local/share/fonts/NerdFonts
    fc-cache -f -v
    sudo rm -r NerdFonts
    echo -e "${GREEN}[DONE] - Fonts set up.${NO_COLOR}"
}

############################ system functions #################################

upgrade () {
    echo -e "${BLUE}[IN PROGRESS] - Upgrading system...${NO_COLOR}"
    sudo apt dist-upgrade -y
    echo -e "${GREEN}[DONE] - System upgraded.${NO_COLOR}"
}

clean () {
    echo -e "${BLUE}[IN PROGRESS] - Cleaning system...${NO_COLOR}"
    sudo apt autoclean
    sudo apt autoremove -y
    echo -e "${GREEN}[DONE] - System cleaned.${NO_COLOR}"
}

att_repos () {
    echo -e "${BLUE}[IN PROGRESS] - Updating repos...${NO_COLOR}"
    sudo apt update -y
    echo -e "${GREEN}[DONE] - Repos updated.${NO_COLOR}"
}

############################### reading files #################################

reading_programs_file () {
    PROGRAMS_APT=()
    PROGRAMS_FLATPAK=()
    PROGRAMS_NIX=()

    while IFS= read -r line; do
        local str_1
        local str_2
        
        str_1=$(echo -e "${line%%,*}")
        str_2=$(echo -e "${line##*,}")

        if [[ $str_2 = "apt" ]]; then
            PROGRAMS_APT+=("$str_1")
        elif [[ $str_2 = "flatpak" ]]; then
            PROGRAMS_FLATPAK+=("$str_1")
        else
            PROGRAMS_NIX+=("$str_1")
        fi
    done < $PROGRAMS_FILE 
}

reading_urls_deb_file () {
    PROGRAMS_DEB=()

    while IFS= read -r line; do
        PROGRAMS_DEB+=("$line")
    done < $DEB_URLS_FILE
}

reading_ppas_file () {
    PPAS=()

    while IFS= read -r line; do
        PPAS+=("$line")
    done < $PPAS_URLS_FILE
}

########################## package installation ###############################

adding_ppas () {
    echo -e "${BLUE}[IN PROGRESS] - Adding PPAs...${NO_COLOR}"
    for ppa in "${PPAS[@]}"; do
        sudo add-apt-repository "$ppa" -y
    done
    echo -e "${GREEN}[DONE] - PPAs added.${NO_COLOR}"
}

download_deb_files () {
    mkdir "$DIR_DOWNLOAD"
    for url in "${PROGRAMS_DEB[@]}"; do
        wget -c "$url" -P "$DIR_DOWNLOAD"
    done
}

install_deb () {
    echo -e "${BLUE}[IN PROGRESS] - Downloading .deb packages...${NO_COLOR}"
    download_deb
    echo -e "${BLUE}[IN PROGRESS] - Installing .deb packages...${NO_COLOR}"
    sudo dpkg -i "$DIR_DOWNLOAD"/*.deb
    echo -e "${BLUE}[IN PROGRESS] - Installing dependencies...${NO_COLOR}"
    sudo apt -f install -y
    echo -e "${GREEN}[DONE] - Repos updated.${NO_COLOR}"
}

install_apt () {
    for program in "${PROGRAMS_APT[@]}"; do
        echo -e "${BLUE}[IN PROGRESS] - Installing $program (apt)...${NO_COLOR}"
        sudo apt install "$program" -y
        echo -e "${GREEN}[DONE] - $program installed.${NO_COLOR}" 
    done
}

install_flatpak () {
    for program in "${PROGRAMS_FLATPAK[@]}"; do
        echo -e "${BLUE}[IN PROGRESS] - Installing $program (flatpak)...${NO_COLOR}"
        flatpak install "$program" -y
        echo -e "${GREEN}[DONE] - $program installed.${NO_COLOR}"
    done
}

install_R_packages () {
    echo -e "${BLUE}[IN PROGRESS] - Installing R dependencies...${NO_COLOR}"
    sudo apt update -qq
    sudo apt install --no-install-recommends software-properties-common dirmngr
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
    echo -e "${BLUE}[IN PROGRESS] - Installing R...${NO_COLOR}"
    sudo apt install r-base r-base-dev -y
    echo -e "${BLUE}[IN PROGRESS] - Installing R packages...${NO_COLOR}"
    Rscript r_packages.R
    echo -e "${GREEN}[DONE] - R packages installed.${NO_COLOR}"
}

install_nix_packages () {
    for program in "${PROGRAMS_NIX[@]}"; do
        echo -e "${BLUE}[IN PROGRESS] - Installing $program (nix)...${NO_COLOR}"
        nix-env -iA nix.pkgs."$program"
        echo -e "${GREEN}[DONE] - $program installed.${NO_COLOR}"
    done
}

install_tutanota () {
    echo -e "${BLUE}[IN PROGRESS] - Downloading Tutanota...${NO_COLOR}"
    mkdir "$HOME"/appimages/
    wget -c "$TUTANOTA_LINK" -P "$HOME"/appimages/ 
    echo -e "${GREEN}[DONE] - Tutanota downloaded.${NO_COLOR}"
}

############################## execution ######################################

att_repos
requirements
remove_locks
add_i386_architecture
setup_nix
setup_docker
setup_fonts
remove_installed
clean
att_repos
upgrade
reading_programs_file
reading_urls_deb_file
reading_ppas_file
install_apt
adding_ppas
download_deb_files
att_repos
install_deb
install_apt
install_flatpak
install_nix
install_tutanota
install_R_packages
clean
setup_fish

sudo rm -r "$DIR_DOWNLOAD"

echo -e "${GREEN}[DONE] - Setup finished.${NO_COLOR}"
