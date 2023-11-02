{
  programs.helix = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../cfg/helix/config.toml);
    languages = builtins.fromTOML (builtins.readFile ../cfg/helix/languages.toml);
   };
}
