{
  lib,
  config,
  ...
}: {
  options.impermanence.enable = lib.mkEnableOption "enable impermanence";

  config = lib.mkIf config.impermanence.enable {
    home.persistence."/persist/home" = {
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Projects"
        "Videos"
        "Zotero"
        ".gnupg"
        ".mozilla"
        ".ssh"
        ".tmux"
        ".config/Bitwarden"
        ".config/Duplicati"
        ".config/obsidian"
        ".config/syncthing"
        ".config/systemd"
        ".local/share/Trash"
        ".local/share/atuin"
        ".local/share/keyrings"
        ".local/share/pano@elhan.io"
        ".local/share/syncthing"
        ".local/share/zoxide"
      ];
    };
  };
}
