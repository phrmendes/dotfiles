let
  inherit (import ../parameters.nix) username;
  bin = "/home/${username}/.nix-profile/bin";
in {
  xdg = {
    enable = true;
    mime.enable = true;
    desktopEntries = {
      nvim = {
        name = "Neovim";
        genericName = "Text Editor";
        comment = "Edit text files";
        exec = "${bin}/nvim-qt --nvim ${bin}/nvim %F";
        icon = "nvim";
        mimeType = [
          "application/x-shellscript"
          "text/english"
          "text/plain"
          "text/x-c"
          "text/x-c++"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-makefile"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
        ];
        terminal = false;
        type = "Application";
        categories = ["Utility" "TextEditor"];
      };
    };
  };
}
