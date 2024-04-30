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
        swaylock = {};
        login = {
          enableGnomeKeyring = true;
          gnupg.enable = true;
        };
      };
    };
  };
}
