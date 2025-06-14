{ parameters, ... }:
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc"
      "/var/cache/tuigreet"
      "/var/db"
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
        ".ssh"
        ".zotero"
        ".cache/cliphist"
        ".cache/helm"
        ".cache/keepassxc"
        ".cache/neovim"
        ".cache/tealdeer"
        ".cache/uv"
        ".local/share"
        ".local/state"
      ];
    };
  };
}
