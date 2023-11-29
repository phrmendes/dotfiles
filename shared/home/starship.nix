{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      docker_context.disabled = true;
      conda.symbol = "󱔎";
    };
  };
}
