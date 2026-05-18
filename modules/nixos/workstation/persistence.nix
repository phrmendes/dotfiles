{ config, ... }:
let
  inherit (config) settings;
  commonDirs = [
    ".aws"
    ".cache"
    ".config"
    ".docker"
    ".gnupg"
    ".kube"
    ".local"
    ".mozilla"
    ".password-store"
    ".pki"
    ".ssh"
    ".zotero"
    "Documents"
    "Downloads"
    "Pictures"
    "Projects"
    "Videos"
    "Zotero"
  ];
in
{
  modules.nixos.workstation.persistence = {
    environment.persistence."/persist".users.${settings.user}.directories = commonDirs ++ [
      {
        directory = ".keychain";
        mode = "u=rwx,go=";
      }
    ];
  };
}
