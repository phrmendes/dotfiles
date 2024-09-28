{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = true;
    pam = {
      services = {
        gdm = {
          enableGnomeKeyring = true;
          gnupg.enable = true;
        };
      };
    };
  };
}
