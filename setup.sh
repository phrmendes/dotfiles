#!/usr/bin/env bash

MAIN_DIR="$(pwd)"
REQUIRED_PROGRAMS=(wget git zip unzip gzip curl file build-essential procps)
TO_REMOVE=(geary gnome-terminal gnome-orca evince totem xterm)
APT_PACKAGES=(file-roller celluloid python3 stow)
FLATPAK_PACKAGES=(com.github.muriloventuroso.easyssh com.mattjakeman.extensionmanager com.stremio.stremio com.github.tchx84.flatseal org.onlyoffice.desktopeditors)

update() {
	sudo apt update -y
	sudo apt full-upgrade -y
}

install_required_programs() {
	sudo apt install ${REQUIRED_PROGRAMS[@]} -y
}

remove_locks() {
	sudo rm /var/lib/dpkg/lock-frontend
	sudo rm /var/cache/apt/archives/lock
	dplg --add-architecture i386
}

remove_programs() {
	apt list --installed | grep libreoffice | cut -d "/" -f 1 | tr '\n' ' ' | xargs sudo apt remove -y
    sudo apt remove "${TO_REMOVE[@]}" -y
	sudo apt autoremove -y
}

install_nix() {
	sh <(curl -L https://nixos.org/nix/install) --daemon
	echo 'export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS' >>"$HOME/.profile"
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

update
install_required_programs
remove_locks
remove_programs
install_nix
install_fonts
install_apt
install_flatpaks
