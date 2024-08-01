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
        ".tmux"
        ".zotero"
        ".local/share/keyrings"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/nix"
        ".local/state/nvim"
      ];
    };
  };
}
