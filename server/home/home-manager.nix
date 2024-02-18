{
  programs.home-manager.enable = true;
  services.home-manager = {
    autoUpgrade = {
      enable = true;
      frequency = "weekly";
    };
  };
}
