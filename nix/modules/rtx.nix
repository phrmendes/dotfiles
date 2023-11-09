{
  programs.rtx = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../cfg/rtx/config.toml);
  };
}
