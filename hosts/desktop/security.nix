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
          kwallet.enable = true;
          gnupg.enable = true;
        };
      };
    };
  };
}
