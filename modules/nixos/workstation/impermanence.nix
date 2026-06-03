{ config, ... }:
let
  inherit (config) settings;
  commonDirs = [
    ".cache/keepassxc"
    ".config"
    ".docker"
    ".kube"
    ".local/share/atuin"
    ".local/share/direnv"
    ".local/share/keyrings"
    ".local/share/k9s"
    ".local/share/mods"
    ".local/share/neovide"
    ".local/share/nix"
    ".local/share/nvim"
    ".local/share/uv"
    ".pi/agent/sessions"
    ".local/share/zathura"
    ".local/share/zoxide"
    ".local/share/zsh"
    ".local/state/comma"
    ".local/state/home-manager"
    ".local/state/keepassxc"
    ".local/state/nix"
    ".local/state/nvim"
    ".local/state/wireplumber"
    ".mozilla"
    ".password-store"
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
  modules.nixos.workstation.impermanence = {
    environment.persistence."/persist".users.${settings.user}.directories = commonDirs ++ [
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".keychain";
        mode = "u=rwx,go=";
      }
    ];
  };
}
