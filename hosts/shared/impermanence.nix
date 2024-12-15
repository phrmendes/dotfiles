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
        ".ansible"
        ".config"
        ".docker"
        ".gnupg"
        ".kube"
        ".mongodb"
        ".mozilla"
        ".pki"
        ".prefect"
        ".ssh"
        ".zotero"
        ".cache/cliphist"
        ".cache/neovim"
        ".cache/tealdeer"
        ".cache/uv"
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
