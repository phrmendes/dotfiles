{
  inputs,
  parameters,
  ...
}: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager"
      "/etc/shadow"
      "/var/log"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.${parameters.user} = {
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
        ".config/Bitwarden"
        ".config/Duplicati"
        ".config/dconf"
        ".config/obsidian"
        ".config/syncthing"
        ".config/systemd"
        ".local/share/Trash"
        ".local/share/atuin"
        ".local/share/keyrings"
        ".local/share/pano@elhan.io"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/nvim"
      ];
    };
  };
}
