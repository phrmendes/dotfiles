{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services = {
        swaylock = {};
        sddm.enableGnomeKeyring = true;
      };
    };
  };
}
