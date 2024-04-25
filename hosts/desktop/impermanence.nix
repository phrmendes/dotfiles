{
  inputs,
  parameters,
  ...
}: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc"
      "/var/lib"
      "/var/log"
    ];
    users.${parameters.user} = {
      files = [
        ".config/gh/hosts.yml"
        ".config/gtkrc"
        ".config/kde.org"
        ".config/kded5rc"
        ".config/kded6rc"
        ".config/kdeglobals"
        ".config/kscreenlockerc"
        ".config/kwinoutputconfig.json"
        ".config/plasma-org.kde.plasma.desktop-appletsrc"
        ".config/plasmarc"
        ".config/plasmashellrc"
        ".config/syncthingtray.ini"
      ];
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Projects"
        "Videos"
        "Zotero"
        ".gnupg"
        ".mozilla"
        ".ssh"
        ".tmux"
        ".config/kde.org"
        ".config/Bitwarden"
        ".config/Duplicati"
        ".config/dconf"
        ".config/obsidian"
        ".config/syncthing"
        ".config/systemd"
        ".local/share/Trash"
        ".local/share/atuin"
        ".local/share/keyrings"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/nvim"
      ];
    };
  };
}
