#!/usr/bin/env bash

MAIN_DIR="$(pwd)"
REQUIRED_PROGRAMS=(wget git zip sqlite unzip gzip curl file build-essential procps libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev llvm fonts-dejavu ca-certificates gnupg)
TO_REMOVE=(gnome-contacts totem geary gnome-terminal gnome-orca evince totem xterm)
APT_PACKAGES=(file-roller celluloid python3 stow alacritty)
FLATPAK_PACKAGES=(com.github.muriloventuroso.easyssh com.mattjakeman.extensionmanager com.stremio.stremio com.github.tchx84.flatseal org.onlyoffice.desktopeditors)
PROTON_DEB=https://proton.me/download/bridge/protonmail-bridge_3.0.21-1_amd64.deb

update() {
	sudo apt update -y
	sudo apt full-upgrade -y
}

install_required_programs() {
	sudo apt install "${REQUIRED_PROGRAMS[@]}" -y
}

remove_locks() {
	sudo rm /var/lib/dpkg/lock-frontend
	sudo rm /var/cache/apt/archives/lock
	dpkg --add-architecture i386
}

remove_programs() {
	apt list --installed | grep libreoffice | cut -d "/" -f 1 | tr '\n' ' ' | xargs sudo apt remove -y
	sudo apt remove "${TO_REMOVE[@]}" -y
	sudo apt autoremove -y
}

install_nix() {
	sh <(curl -L https://nixos.org/nix/install) --daemon
	echo "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS" >>"$HOME/.profile"
	source "$HOME/.profile"
}

install_fonts() {
	mkdir -p "$HOME/.local/share/fonts/"
	cp "$MAIN_DIR/resources/SauceCodePro.zip" "$HOME/.local/share/fonts/"
	cd "$HOME/.local/share/fonts/" || exit
	unzip SauceCodePro.zip
	rm SauceCodePro.zip
	fc-cache -f -v
	cd "$MAIN_DIR" || exit
}

install_apt() {
	sudo apt install "${APT_PACKAGES[@]}" -y
}

install_flatpaks() {
	for program in "${FLATPAK_PACKAGES[@]}"; do
		flatpak install "$program" -y
	done
}

install_proton_bridge() {
	wget -O /tmp/proton.deb "$PROTON_DEB"
	sudo dpkg -i /tmp/proton.deb
	sudo dpkg-reconfigure protonmail-bridge
}

install_docker() {
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker "$USER"
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service
}

python_setup() {
	curl https://pyenv.run | bash
	"$HOME/.pyenv/bin/pyenv" install 3.11.3
	"$HOME/.pyenv/bin/pyenv" global 3.11.3
}

update
install_required_programs
remove_locks
remove_programs
install_nix
install_fonts
install_apt
install_flatpaks
install_proton_bridge
install_docker
python_setup
