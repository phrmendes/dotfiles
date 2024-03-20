{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services = {
        swaylock = {};
        gdm.enableGnomeKeyring = true;
      };
    };
  };
}
