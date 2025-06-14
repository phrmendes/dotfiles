{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = true;
    pam = {
      services = {
        hyprlock = { };
        greetd = {
          gnupg.enable = true;
        };
      };
    };
  };
}
