#!/usr/bin/env bash

# ------------------------------------- #
# ------------- VARIABLES ------------- #
# ------------------------------------- #

ARCHITECTURE=$(dpkg --print-architecture)
BOLD_GREEN="\e[1;32m"
END_COLOR="\e[0m"
MAIN_DIR="$(pwd)"
NIX_BIN="/nix/var/nix/profiles/default/bin/"
PYENV_PATH="$HOME/.pyenv"
PYENV_BIN="$PYENV_PATH/bin/pyenv"
PYTHON_BIN="$PYENV_PATH/shims/python"
UBUNTU_VERSION=$(. /etc/os-release && echo "$VERSION_CODENAME")
USER=$(whoami)

DEB_PACKAGES=(
	"proton:proton.me/download/bridge/protonmail-bridge_3.0.21-1_amd64.deb"
	"wezterm:github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu22.04.deb"
)

TO_REMOVE=(
	gnome-contacts gnome-calendar totem geary gnome-terminal
	gnome-orca evince totem xterm fprintd simple-scan
)

REQUIRED_PROGRAMS=(
	wget git zip sqlite unzip gzip curl file build-essential
	libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev
	libffi-dev liblzma-dev fonts-dejavu ca-certificates gnupg
)

APT_PACKAGES=(
	file-roller python3 stow rename sqlite docker-ce
	docker-ce-cli containerd.io docker-buildx-plugin
	docker-compose-plugin
)

FINGERPRINT_PACKAGES=(open-fprintd fprintd-clients python3-validity)

PPAS=(
	ppa:uunicorn/open-fprintd
)

FLATPAK_PACKAGES=(
	com.github.tchx84.flatseal
	com.mattjakeman.extensionmanager
	org.onlyoffice.desktopeditors
	org.gnome.Boxes
)

PYTHON_PACKAGES=(
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

setup_docker() {
	echo -e "${BOLD_GREEN}Setting up Docker...${END_COLOR}"
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$ARCHITECTURE signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_VERSION stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo usermod -aG docker "$USER"
	update
}

install_nix() {
	echo -e "${BOLD_GREEN}Installing Nix package manager...${END_COLOR}"
	sh <(curl -L https://nixos.org/nix/install) --daemon
	export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
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
		key="${program%%:*}"   # deletes after ":"
		value="${program##*:}" # deletes before ":"

		wget -O /tmp/"${key}.deb" "https://${value}"
		sudo dpkg --install /tmp/"${key}.deb" -y
	done

	sudo apt --fix-broken install -y
}

fingerprint_setup() {
	echo -e "${BOLD_GREEN}Setting up fingerprint...${END_COLOR}"
	clean
	fprintd-enroll
}

home_manager_setup() {
	"$NIX_BIN/nix-channel" --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	"$NIX_BIN/nix-channel" --update
	export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"
}

home_manager_first_generation() {
	"$NIX_BIN/nix-shell" '<home-manager>' -A install
}

stow_dotfiles() {
	rm "$HOME/.config/home-manager/home.nix"
	rm "$HOME/.profile"
	stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
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
	cd "$MAIN_DIR" || exit
}

fingerprint_setup() {
	echo -e "${BOLD_GREEN}Setting up fingerprint...${END_COLOR}"
	update
	sudo apt install "${FINGERPRINT_PACKAGES[@]}" -y
	clean
	fprintd-enroll
}

# ------------------------------------- #
# ------------- EXECUTION ------------- #
# ------------------------------------- #

update
remove_locks
install_required_programs
remove_programs
setup_docker
install_nix
add_ppas
install_apt
install_flatpaks
install_deb
home_manager_setup
home_manager_first_generation
stow_dotfiles
setup_python
install_py_packages
setup_poetry
setup_python_debugger

echo -e "Configure fingerprint? [y/n]"
read -r fingerprint

if [[ "$fingerprint" == "y" ]]; then
	fingerprint_setup
fi
