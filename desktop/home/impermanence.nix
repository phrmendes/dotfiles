{lib, ...}: let
  inherit (lib) forEach;
in {
  home.persistence."/persistent/home/phrmendes" = {
    allowOther = true;
    files = [
      ".openai_api_key.gpg"
      ".zsh_history"
    ];
    directories =
      [
        "Download"
        "Videos"
        "Documents"
        "Projects"
        "Zotero"
        "other"
        ".gnupg"
        ".ssh"
        ".mozilla"
      ]
      ++ forEach [
        "Bitwarden"
        "Duplicati"
        "gh"
        "obsidian"
        "pop-shell"
        "syncthing"
      ] (
        dir: ".config/${dir}"
      )
      ++ forEach [
        "mozilla"
        "tealdeer"
        "zellij"
      ] (
        dir: ".cache/${dir}"
      )
      ++ forEach [
        "share/keyrings"
        "state/ltex"
        "state/nvim"
      ] (dir: ".local/${dir}");
  };
}
