{ config, ... }:
let
  inherit (config) settings;
  commonDirs = [
    ".aws"
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
    ".local/share/opencode"
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
    ".local/state/opencode"
    ".local/state/qalculate"
    ".local/state/wireplumber"
    ".mozilla"
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
