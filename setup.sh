#!/usr/bin/env bash

# ------------------------------------- #
# ------------- VARIABLES ------------- #
# ------------------------------------- #

BOLD_GREEN="\e[1;32m"
END_COLOR="\e[0m"
MAIN_DIR="$(pwd)"
PYTHON_PATH="$HOME/.pyenv/bin"

DEB_PACKAGES=(
	https://proton.me/download/bridge/protonmail-bridge_3.0.21-1_amd64.deb
)

TO_REMOVE=(
	gnome-contacts gnome-calendar totem geary
	gnome-terminal gnome-orca evince totem xterm
	fprintd
)

REQUIRED_PROGRAMS=(
	wget git zip sqlite unzip gzip curl file build-essential
	procps libssl-dev zlib1g-dev libbz2-dev libreadline-dev
	libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev
	libxmlsec1-dev libffi-dev liblzma-dev llvm fonts-dejavu
	ca-certificates gnupg
)

APT_PACKAGES=(
	file-roller python3 stow alacritty podman rename
	open-fprintd fprintd-clients python3-validity
)

PPAS=(
	ppa:uunicorn/open-fprintd
)

FLATPAK_PACKAGES=(
	com.github.muriloventuroso.easyssh
	com.github.tchx84.flatseal
	com.mattjakeman.extensionmanager
	com.stremio.stremio
	org.onlyoffice.desktopeditors
	io.podman_desktop.PodmanDesktop
	org.gnome.Boxes
)

PYTHON_PACKAGES=(
	mypy
	podman-compose
	poetry
	ptipython
)

# ------------------------------------- #
# ------------- FUNCTIONS ------------- #
# ------------------------------------- #

clean() {
	echo -e "${BOLD_GREEN}Cleaning up...${END_COLOR}"
	sudo apt clean
	sudo apt autoclean
	sudo apt autoremove
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

install_fonts() {
	echo -e "${BOLD_GREEN}Installing fonts...${END_COLOR}"
	mkdir -p "$HOME/.local/share/fonts/"
	cp "$MAIN_DIR/resources/SauceCodePro.zip" "$HOME/.local/share/fonts/"
	cd "$HOME/.local/share/fonts/" || exit
	unzip SauceCodePro.zip
	rm SauceCodePro.zip
	fc-cache -f -v
	cd "$MAIN_DIR" || exit
}

add_ppas() {
	echo -e "${BOLD_GREEN}Adding PPAs...${END_COLOR}"

	for ppa in "${PPAS[@]}"; do
		sudo add-apt-repository "$ppa" -y
	done

	update
}

install_apt() {
	echo -e "${BOLD_GREEN}Installing apt packages...${END_COLOR}"
	sudo apt install "${APT_PACKAGES[@]}" -y
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
		wget -O /tmp/"${program}" "$program"
		sudo dpkg -i /tmp/"${program}"
	done

	sudo dpkg-reconfigure --all
}

fingerprint_setup() {
	echo -e "${BOLD_GREEN}Setting up fingerprint...${END_COLOR}"
	clean
	fprintd-enroll
}

home_manager_setup() {
	/nix/var/nix/profiles/default/bin/nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	/nix/var/nix/profiles/default/bin/nix-channel --update
	export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"
}

home_manager_first_generation() {
	/nix/var/nix/profiles/default/bin/nix-shell '<home-manager>' -A install
}

home_manager_update() {
	"$HOME/.nix-profile/bin/home-manager" switch
}

stow_dotfiles() {
	rm "$HOME/.config/home-manager/home.nix"
	rm "$HOME/.profile"
	stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
}

setup_python() {
	curl https://pyenv.run | bash
	"$PYTHON_PATH/pyenv" install 3.11.3
	"$PYTHON_PATH/pyenv" global 3.11.3
}

install_py_packages() {
	echo -e "${BOLD_GREEN}Installing python packages...${END_COLOR}"
	"$PYTHON_PATH/python" -m pip install --upgrade pip
	"$PYTHON_PATH/python" -m pip install "${PYTHON_PACKAGES[@]}"
}

setup_poetry() {
	"$PYTHON_PATH/poetry" config virtualenvs.in-project true
}

setup_python_debugger() {
	mkdir "$HOME/.virtualenvs"
	cd "$HOME/.virtualenvs" || exit
	"$PYTHON_PATH/python" -m venv debugpy
	"$HOME/.virtualenvs/debugpy/bin/python" -m pip install --upgrade pip
	"$HOME/.virtualenvs/debugpy/bin/python" -m pip install debugpy
	cd "$MAIN_DIR" || exit
}

# ------------------------------------- #
# ------------- EXECUTION ------------- #
# ------------------------------------- #

update
remove_locks
install_required_programs
remove_programs
install_fonts
install_nix
add_ppas
install_apt
install_flatpaks
install_deb
stow_dotfiles
home_manager_setup
home_manager_first_generation
home_manager_update
setup_python
install_py_packages
setup_poetry
setup_python_debugger

echo -e "Configure fingerprint? [y/n]"
read -r fingerprint

if [[ "$fingerprint" == "y" ]]; then
	fingerprint_setup
fi
