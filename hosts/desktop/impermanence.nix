{parameters, ...}: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc"
      "/var/lib"
      "/var/log"
    ];
    users.${parameters.user} = {
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Projects"
        "Videos"
        "Zotero"
        "go"
        ".config"
        ".gnupg"
        ".mozilla"
        ".ssh"
        ".local/share/atuin"
        ".local/share/keyrings"
        ".local/share/plex"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/nvim"
      ];
    };
  };
}
