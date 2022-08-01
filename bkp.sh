#!/bin/bash

DEB_URLS_FILE="deb_urls.txt"
PROGRAMS_FILE="programs.txt"
DIR_DOWNLOAD="$HOME/Downloads/deb_packages"
PPAS_URLS_FILE="ppas.txt"
R_PACKAGES_FILE="r_packages.R"
TUTANOTA_LINK="https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage"

reading_programs_variables () {
    while IFS= read -r line; do
        PROGRAMS_APT=()
        PROGRAMS_FLATPAK=()
        PROGRAMS_SNAP=()
        PROGRAMS_BREW=()

        local str_1=$(echo ${line%%,*})
        local str_2=$(echo ${line##*,})

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
    while IFS= read -r line; do
        PPAS=()

        PPAS+=("$line")
    done < $PPAS_URLS_FILE
}

remove_locks () {
    echo "[INFO] - Removendo locks"
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
}

add_i386_architecture () {
    echo "[INFO] - Adicionando arquitetura x86"
    sudo dpkg --add-architecture i386
}

att_repos () {
    echo "[INFO] - Atualizando repositórios"
    sudo apt update -y
}

download_deb () {
    mkdir "$DIR_DOWNLOAD"
    for url in ${PROGRAMS_DEB[@]}; do
        wget -c "$url" -P "$DIR_DOWNLOAD"
    done
}

install_deb () {
    echo "[INFO] - Download de pacotes .deb"
    download_deb
    echo "[INFO] - Instalando pacotes .deb"
    sudo dpkg -i $DIR_DOWNLOAD/*.deb
    echo "[INFO] - Instalando dependências"
    sudo apt -f install -y
}

install_apt () {
    for program in ${PROGRAMS_APT[@]}; do
        if ! dpkg -l | grep -q $program; then
            echo "[INFO] - Instalando $program (apt)"
            sudo apt install $program -y
        else
            echo "[INFO] - $program já instalado"
        fi
    done
}

install_flatpak () {
    for program in ${PROGRAMS_FLATPAK[@]}; do
        echo "[INFO] - Instalando $program (flatpak)"
        flatpak install $program -y
    done
}

install_snap () {
    for program in ${PROGRAMS_SNAP[@]}; do
        echo "[INFO] - Instalando $program (snap)"
        sudo snap install $program
    done
}

homebrew () {
    echo "[INFO] - Instalando homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.zshrc && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
}

install_brew () {
    for program in ${PROGRAMS_BREW[@]}; do
        echo "[INFO] - Instalando $program (brew)"
        brew install $program
    done
}

install_R_packages () {

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
    echo "[INFO] - Adicionando PPA's"
    for ppa in ${PPAS[@]}; do
        sudo add-apt-repository $ppa -y
    done
}

zsh_p10k () {

    echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
    chsh -s $(which zsh)

}

zsh_p10k_root () {

    zsh && p10k configure

    local files=(powerlevel10k .zshrc .p10k.zsh)

    for i in ${files[@]}; do
        sudo ln -s $HOME/$i /root/$i
        sudo chmod 744 /root/$i
    done

}

tutanota_download () {

    mkdir $HOME/appimages/
    wget -c "$TUTANOTA_LINK" -P $HOME/appimages/ 

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
install_apt
install_deb
install_flatpak
install_snap
install_brew
tutanota_download
install_R_packages
zsh_p10k
zsh_p10k_root
clean

sudo rm -r $DIR_DOWNLOAD

echo "[INFO] - Finalizado"
