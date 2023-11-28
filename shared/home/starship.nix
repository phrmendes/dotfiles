{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      docker_context.disabled = true;
    };
  };
}
