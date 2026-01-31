{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
