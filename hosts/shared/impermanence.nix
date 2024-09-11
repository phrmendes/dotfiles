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
        ".kube"
        ".mozilla"
        ".ssh"
        ".tmux"
        ".zotero"
        ".cache/tealdeer"
        ".cache/uv"
        ".local/share/Trash"
        ".local/share/keyrings"
        ".local/share/nvim"
        ".local/share/plex"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/lazygit"
        ".local/state/nix"
        ".local/state/nvim"
        ".local/state/uv"
        ".local/state/wireplumber"
      ];
    };
  };
}
