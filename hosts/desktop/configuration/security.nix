{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
    pam = {
      services = {
        login = {
          enableGnomeKeyring = true;
          gnupg.enable = true;
        };
      };
    };
  };
}
