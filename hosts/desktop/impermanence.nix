{
  inputs,
  parameters,
  ...
}: {
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
        ".logseq"
        ".mozilla"
        ".ssh"
        ".tmux"
        ".vscode"
        ".local/share/Trash"
        ".local/share/atuin"
        ".local/share/keyrings"
        ".local/share/klipper"
        ".local/share/kwalletd"
        ".local/share/syncthing"
        ".local/share/zoxide"
        ".local/state/nvim"
      ];
    };
  };
}
