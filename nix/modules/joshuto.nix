{
  programs.joshuto = {
    enable = true;
    mimetype = builtins.fromTOML (builtins.readFile ../cfg/joshuto/mimetype.toml);
    settings = builtins.fromTOML (builtins.readFile ../cfg/joshuto/joshuto.toml);
  };
}
