{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services = {
        swaylock = {};
        login.enableGnomeKeyring = true;
      };
    };
  };
}
