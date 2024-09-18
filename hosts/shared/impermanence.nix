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
        ".prefect"
        ".ssh"
        ".zotero"
        ".cache/tealdeer"
        ".cache/uv"
        ".cache/zotcite"
        ".local/share/Trash"
        ".local/share/keyrings"
        ".local/share/nvim"
        ".local/share/plex"
        ".local/share/syncthing"
        ".local/share/wezterm"
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
