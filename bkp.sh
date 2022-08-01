#!/bin/bash

DEB_URLS_FILE="deb_urls.txt"
PROGRAMS_FILE="programs.txt"
DIR_DOWNLOAD="$HOME/Downloads/deb_packages"

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
    done < $DEB_URlS_FILE
}

is_installed () {
    if dpkg -l | grep -q $1; then
        exit 0
    else
        exit 1
    fi
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
    [[ ! -d "$DIR_DOWNLOAD" ]] && mkdir "$DIR_DOWNLOAD"
    for program in ${PROGRAMS_DEB[@]}; do
        wget -c "$program" -P "$DIR_DOWNLOAD"
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
        if ! is_installed program; then
            echo "[INFO] - Instalando $program"
            sudo apt install $program -y
        else
            echo "[INFO] - $program já instalado"
        fi
    done
}

install_flatpak () {
    for program in ${PROGRAMS_APT[@]}; do
        echo "[INFO] - Instalando $program"
        flatpak install $program -y
    done
}

install_snap () {
    for program in ${PROGRAMS_APT[@]}; do
        echo "[INFO] - Instalando $program"
        sudo snap install $program
    done
}

homebrew () {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.zshrc && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
}

upgrade_cleaning () {
    sudo apt dist-upgrade -y
    sudo apt autoclean
    sudo apt autoremove -y
}

if [[ ! -x `which wget` ]]; then
    sudo apt install wget -y
fi

reading_programs_variables
remove_locks
add_i386_architecture
att_repos
download_deb
install_deb
install_apt
install_flatpak
install_snap
upgrade_cleaning

sudo rm -r $DIR_DOWNLOAD

echo "[INFO] - Finalizado"
