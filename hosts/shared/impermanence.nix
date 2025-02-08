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
        ".local/share"
        ".local/state"
      ];
    };
  };
}
