{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = true;
    pam = {
      services = {
        swaylock = {};
        greetd = {
          gnupg.enable = true;
          enableGnomeKeyring = true;
        };
      };
    };
  };
}
