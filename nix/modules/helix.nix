{
  programs.helix = {
    enable = true;
    languages = builtins.fromTOML (builtins.readFile ../cfg/helix/languages.toml);
    settings = builtins.fromTOML (builtins.readFile ../cfg/helix/settings.toml);
  };
}
