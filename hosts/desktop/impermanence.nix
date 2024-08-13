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
        ".config"
        ".gnupg"
        ".mozilla"
        ".ssh"
        ".zotero"
        ".cache/zellij"
        ".cache/tealdeer"
        ".local/share/Trash"
        ".local/share/keyrings"
        ".local/share/nvim"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/lazygit"
        ".local/state/nix"
        ".local/state/nvim"
        ".local/state/wireplumber"
      ];
    };
  };
}
