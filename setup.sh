#!/usr/bin/env bash

APPIMAGES=("pcloud:https://p-def8.pcloud.com/cBZYvCrtdZgNj4RoZZZhq1do7Z2ZZSzRZkZW10DVZAZHkZppZ94ZJ7ZfzZR4ZNVZX5ZGRZ8VZqzZeFZlHZecm6VZiH3dGJDvi3zvgvVdjGzzPJ3ppHLk/pcloud")
BOLD_GREEN="\e[1;32m"
CWD=$(pwd)
END_COLOR="\e[0m"
FINGERPRINT_PACKAGES=(open-fprintd fprintd-clients python3-validity)
FLATPAK_PACKAGES=(com.mattjakeman.extensionmanager)
FPRINT_PPA=ppa:uunicorn/open-fprintd
NIX_BIN="/nix/var/nix/profiles/default/bin/"
PYENV_BIN="$PYENV_PATH/bin/pyenv"
PYENV_PATH="$HOME/.pyenv"
PYTHON_BIN="$PYENV_PATH/shims/python"
PYTHON_PACKAGES=(poetry ptipython)
USER=$(whoami)

DEB_PACKAGES=(
	"proton:proton.me/download/bridge/protonmail-bridge_3.0.21-1_amd64.deb"
	"wezterm:github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu22.04.deb"
)

TO_REMOVE=(
	gnome-contacts gnome-calendar totem gnome-terminal
	gnome-orca evince totem xterm fprintd simple-scan
)

REQUIRED_PROGRAMS=(
	wget git zip unzip gzip curl file gnupg build-essential fonts-dejavu
	gdebi-core ca-certificates libssl-dev zlib1g-dev libbz2-dev libreadline-dev
	libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev
	libffi-dev liblzma-dev file-roller
)

clean() {
	echo -e "${BOLD_GREEN}Cleaning up...${END_COLOR}"
	sudo apt clean
	sudo apt autoclean
	sudo apt autoremove -y
}

update() {
	echo -e "${BOLD_GREEN}Updating...${END_COLOR}"
	sudo apt update -y
	sudo apt dist-upgrade -y
}

remove_locks() {
	echo -e "${BOLD_GREEN}Removing locks...${END_COLOR}"
	sudo rm /var/lib/dpkg/lock-frontend
	sudo rm /var/cache/apt/archives/lock
	sudo dpkg --add-architecture i386
}

install_required_programs() {
	echo -e "${BOLD_GREEN}Installing required programs...${END_COLOR}"
	sudo apt install "${REQUIRED_PROGRAMS[@]}" -y
}

remove_programs() {
	echo -e "${BOLD_GREEN}Removing programs...${END_COLOR}"
	apt list --installed | grep libreoffice | cut -d "/" -f 1 | tr '\n' ' ' | xargs sudo apt remove -y
	sudo apt remove "${TO_REMOVE[@]}" -y
	clean
}

install_nix() {
	echo -e "${BOLD_GREEN}Installing Nix package manager...${END_COLOR}"
	sh <(curl -L https://nixos.org/nix/install) --daemon
	export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
}

install_flatpaks() {
	echo -e "${BOLD_GREEN}Installing flatpaks...${END_COLOR}"

	for program in "${FLATPAK_PACKAGES[@]}"; do
		flatpak install "$program" -y
	done
}

install_deb() {
	echo -e "${BOLD_GREEN}Installing .deb packages...${END_COLOR}"

	for program in "${DEB_PACKAGES[@]}"; do
		key="${program%%:*}"   # deletes after ":"
		value="${program##*:}" # deletes before ":"

		wget -O "/tmp/${key}.deb" "https://${value}"
		sudo gdebi "/tmp/${key}.deb" -n
	done

	sudo apt --fix-broken install -y
}

download_appimages() {
	echo -e "${BOLD_GREEN}Downloading AppImages...${END_COLOR}"

	for program in "${APPIMAGES[@]}"; do
		key="${program%%:*}"   # deletes after ":"
		value="${program##*:}" # deletes before ":"

		wget -O "/tmp/${key}.AppImage" "https://${value}"
		chmod +x "/tmp/${key}.AppImage"
		mkdir -p "$HOME/AppImage"
		mv "/tmp/${key}.AppImage" "$HOME/AppImage"
	done
}

home_manager_setup() {
	"$NIX_BIN/nix-channel" --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	"$NIX_BIN/nix-channel" --update
	export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"
	"$NIX_BIN/nix-shell" '<home-manager>' -A install
	rm "$HOME"/.config/home-manager/*
	ln -s "$CWD/nix/home.nix" "$HOME/.config/home-manager/home.nix"
	"$HOME/.nix-profile/bin/home-manager" switch
}

setup_python() {
	curl https://pyenv.run | bash
	"$PYENV_BIN" install 3.11.3
	"$PYENV_BIN" global 3.11.3
}

install_py_packages() {
	echo -e "${BOLD_GREEN}Installing python packages...${END_COLOR}"
	"$PYTHON_BIN" -m pip install --upgrade pip
	"$PYTHON_BIN" -m pip install "${PYTHON_PACKAGES[@]}"
}

setup_poetry() {
	"$PYTHON_BIN" -m poetry config virtualenvs.in-project true
}

setup_python_debugger() {
	mkdir "$HOME/.virtualenvs"
	cd "$HOME/.virtualenvs" || exit
	"$PYTHON_BIN" -m venv debugpy
	"$HOME/.virtualenvs/debugpy/bin/python" -m pip install --upgrade pip
	"$HOME/.virtualenvs/debugpy/bin/python" -m pip install debugpy
	cd "$CWD" || exit
}

fingerprint_setup() {
	echo -e "${BOLD_GREEN}Setting up fingerprint...${END_COLOR}"
	sudo add-apt-repository "$FPRINT_PPA" -y
	update
	sudo apt install "${FINGERPRINT_PACKAGES[@]}" -y
	clean
	fprintd-enroll
}

update
remove_locks
install_required_programs
remove_programs
install_nix
install_flatpaks
install_deb
home_manager_setup
setup_python
install_py_packages
setup_poetry
setup_python_debugger
download_appimages

echo -e "Configure fingerprint? [y/n]"
read -r fingerprint

if [[ "$fingerprint" == "y" ]]; then
	fingerprint_setup
fi
