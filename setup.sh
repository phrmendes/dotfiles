#!/usr/bin/env bash

BOLD_GREEN="\e[1;32m"
CWD=$(pwd)
END_COLOR="\e[0m"
FPRINT_PPA="ppa:uunicorn/open-fprintd"
LOCAL_BIN="$HOME/.local/bin"
NIX_BIN="/nix/var/nix/profiles/default/bin/"
USER=$(whoami)
USER_THEME="Catppuccin-Macchiato-Standard-Blue-Dark"
USER_THEME_URL="https://github.com/catppuccin/gtk/releases/download/v0.6.0/$USER_THEME.zip"
APPIMAGES_PACKAGES=("pcloud:p-def8.pcloud.com/cBZYvCrtdZgNj4RoZSRFj7Z7ZibYAo7Z2ZZSzRZkZW10DVZAZHkZppZ94ZJ7ZfzZR4ZNVZX5ZGRZ8VZqzZeFZlHZecm6VZOHixUKea1luCC5wSxpIicXnmIry7/pcloud")
APT_PACKAGES=(build-essential ca-certificates curl file file-roller fonts-dejavu gdebi-core gnupg gzip libbz2-dev libffi-dev libfuse2 liblzma-dev libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxmlsec1-dev rar tk-dev uidmap unrar unzip wget xz-utils zip zlib1g-dev gnome-tweaks tailscale openssh-server)
FINGERPRINT_PACKAGES=(open-fprintd fprintd-clients python3-validity)
FLATPAK_PACKAGES=(com.mattjakeman.ExtensionManager)
PACKAGES_TO_REMOVE=(gnome-contacts gnome-calendar totem gnome-terminal geary evince totem xterm fprintd simple-scan gparted)
PYTHON_PACKAGES=(poetry ptipython)

DEB_PACKAGES=(
	"wezterm:github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu22.04.deb"
	"protonbridge:proton.me/download/bridge/protonmail-bridge_3.2.0-1_amd64.deb"
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

install_apt() {
	echo -e "${BOLD_GREEN}Installing required programs...${END_COLOR}"
	sudo apt install "${APT_PACKAGES[@]}" -y
}

remove_programs() {
	echo -e "${BOLD_GREEN}Removing programs...${END_COLOR}"
	apt list --installed | grep libreoffice | cut -d "/" -f 1 | tr '\n' ' ' | xargs sudo apt remove -y
	sudo apt remove "${PACKAGES_TO_REMOVE[@]}" -y
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

	sudo flatpak override --filesystem="$HOME/.themes"
}

home_manager_setup() {
	export NIXPKGS_ALLOW_UNFREE=1

	"$NIX_BIN/nix-channel" --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	"$NIX_BIN/nix-channel" --update
	"$NIX_BIN/nix-shell" '<home-manager>' -A install

	export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"

	rm "$HOME"/.config/home-manager/*
	rm "$HOME/.profile"
	ln -s "$CWD/nix/home.nix" "$HOME/.config/home-manager/home.nix"
	"$HOME/.nix-profile/bin/home-manager" switch
}

python_setup() {
	echo -e "${BOLD_GREEN}Setting up python...${END_COLOR}"
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
	source "$HOME/.asdf/asdf.sh"
	asdf plugin add python
	asdf install python 3.11.3
	asdf global python 3.11.3

	echo -e "${BOLD_GREEN}Installing python packages...${END_COLOR}"
	python -m pip install --upgrade pip
	python -m pip install "${PYTHON_PACKAGES[@]}"

	echo -e "${BOLD_GREEN}Setting up poetry...${END_COLOR}"
	python -m poetry config virtualenvs.in-project true

	echo -e "${BOLD_GREEN}Setting up python debugger...${END_COLOR}"
	mkdir "$HOME/.virtualenvs"
	cd "$HOME/.virtualenvs" || exit
	python -m venv debugpy
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

download_appimages() {
	echo -e "${BOLD_GREEN}Downloading AppImages...${END_COLOR}"

	for program in "${APPIMAGES_PACKAGES[@]}"; do
		key="${program%%:*}"   # deletes after ":"
		value="${program##*:}" # deletes before ":"

		mkdir -p "$LOCAL_BIN"
		wget -O "$LOCAL_BIN/${key}" "https://${value}"
		chmod +x "$LOCAL_BIN/${key}"
	done
}

install_deb() {
	echo -e "${BOLD_GREEN}Installing deb packages...${END_COLOR}"

	for program in "${DEB_PACKAGES[@]}"; do
		key="${program%%:*}"   # deletes after ":"
		value="${program##*:}" # deletes before ":"

		wget -O "/tmp/${key}.deb" "https://${value}"
		sudo gdebi "/tmp/${key}.deb"
	done
}

install_theme() {
	echo -e "${BOLD_GREEN}Installing theme...${END_COLOR}"
	mkdir -p "$HOME/.themes"
	wget -O "$HOME/.themes/theme.zip" $USER_THEME_URL
	unzip "$HOME/.themes/theme.zip" -d "$HOME/.themes"
	rm "$HOME/.themes/theme.zip"

	echo -e "${BOLD_GREEN}Configuring gtk-4.0 themes...${END_COLOR}"
	mkdir -p "${HOME}/.config/gtk-4.0"
	ln -sf "${HOME}/.themes/${USER_THEME}/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
	ln -sf "${HOME}/.themes/${USER_THEME}/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
	ln -sf "${HOME}/.themes/${USER_THEME}/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"

	echo -e "${BOLD_GREEN}Configuring flatpaks...${END_COLOR}"
	sudo flatpak override --filesystem="$HOME/.themes"
	sudo flatpak override --env=GTK_THEME="${USER_THEME}"
}

tailscale_repo() {
	echo -e "${BOLD_GREEN}Adding Tailscale repository...${END_COLOR}"
	sudo curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
	sudo curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list >/dev/null
	update
}

update
remove_locks
remove_programs
tailscale_repo
install_apt
install_nix
install_flatpaks
install_deb
download_appimages
home_manager_setup
python_setup
install_theme

read -rp "Configure fingerprint? [y/n] " fingerprint
[[ "$fingerprint" == "y" ]] && fingerprint_setup
