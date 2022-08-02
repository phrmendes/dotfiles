#!/bin/bash

DEB_URLS_FILE="deb_urls.txt"
PROGRAMS_FILE="programs.txt"
DIR_DOWNLOAD="$HOME/Downloads/deb_packages"
PPAS_URLS_FILE="ppas.txt"
R_PACKAGES_FILE="r_packages.R"
TUTANOTA_LINK="https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage"

reading_programs_variables () {
    PROGRAMS_APT=()
    PROGRAMS_FLATPAK=()
    PROGRAMS_SNAP=()
    PROGRAMS_BREW=()

    while IFS= read -r line; do
        local str_1=$(echo -e ${line%%,*})
        local str_2=$(echo -e ${line##*,})

        if [[ $str_2 = "apt" ]]; then
            PROGRAMS_APT+=("$str_1")
        elif [[ $str_2 = "flatpak" ]]; then
            PROGRAMS_FLATPAK+=("$str_1")
        elif [[ $str_2 = "snap" ]]; then
            PROGRAMS_SNAP+=("$str_1")
        else
            PROGRAMS_BREW+=("$str_1")
        fi
    done < $PROGRAMS_FILE 
}

reading_urls_deb () {
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

remove_locks () {
    echo -e "[INFO] - Removendo locks"
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
}

add_i386_architecture () {
    echo -e "[INFO] - Adicionando arquitetura x86"
    sudo dpkg --add-architecture i386
}

att_repos () {
    echo -e "[INFO] - Atualizando repositórios"
    sudo apt update -y
}

download_deb () {
    mkdir "$DIR_DOWNLOAD"
    for url in ${PROGRAMS_DEB[@]}; do
        wget -c "$url" -P "$DIR_DOWNLOAD"
    done
}

install_deb () {
    echo -e "[INFO] - Download de pacotes .deb"
    download_deb
    echo -e "[INFO] - Instalando pacotes .deb"
    sudo dpkg -i $DIR_DOWNLOAD/*.deb
    echo -e "[INFO] - Instalando dependências"
    sudo apt -f install -y
}

install_apt () {
    for program in ${PROGRAMS_APT[@]}; do
        echo -e "[INFO] - Instalando $program (apt)"
        sudo apt install $program -y
    done
}

install_flatpak () {
    for program in ${PROGRAMS_FLATPAK[@]}; do
        echo -e "[INFO] - Instalando $program (flatpak)"
        flatpak install $program -y
    done
}

install_snap () {
    for program in ${PROGRAMS_SNAP[@]}; do
        echo -e "[INFO] - Instalando $program (snap)"
        sudo snap install $program
    done
}

homebrew () {
    echo -e "[INFO] - Instalando homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/config/fish/config.fish && echo -e "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/config/fish/config.fish
    echo -e "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/config/fish/config.fish
    test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
}

install_brew () {
    for program in ${PROGRAMS_BREW[@]}; do
        echo -e "[INFO] - Instalando $program (brew)"
        brew install $program
    done
}

install_R_packages () {

    sudo apt update -qq

    sudo apt install --no-install-recommends software-properties-common dirmngr

    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

    sudo apt install r-base r-base-dev -y

    Rscript r_packages.R

}

upgrade () {
    sudo apt dist-upgrade -y
}

clean () {
    sudo apt autoclean
    sudo apt autoremove -y
}

adding_ppas () {
    echo -e "[INFO] - Adicionando PPA's"
    for ppa in ${PPAS[@]}; do
        sudo add-apt-repository $ppa -y
    done
}

tutanota_download () {

    mkdir $HOME/appimages/
    wget -c "$TUTANOTA_LINK" -P $HOME/appimages/ 

}

emacs_settings () {

    git clone https://github.com/phrmendes/emacs_settings.git $HOME/.emacs.d/

}

remove_installed () {
    local libreoffice=$(apt list --installed | grep libreoffice | cut -d "/" -f 1)

    local apps=(geary gnome-calendar gnome-contacts)

    for program in ${libreoffice}; do
        echo -e "[INFO] - Removendo $program (apt)"
        sudo apt remove $program -y
    done

    for program in ${apps}; do
        echo -e "[INFO] - Removendo $program (apt)"
        sudo apt remove $program -y
    done
}

if [[ ! -x `which wget` ]]; then
    sudo apt install wget -y
fi

reading_programs_variables
reading_urls_deb
reading_ppas_file
remove_locks
add_i386_architecture
att_repos
adding_ppas
upgrade
homebrew
remove_installed
install_apt
install_deb
install_flatpak
install_snap
install_brew
tutanota_download
install_R_packages
emacs_settings
clean

sudo rm -r $DIR_DOWNLOAD

echo -e "[INFO] - Finalizado"
