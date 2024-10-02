{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = true;
    pam = {
      services = {
        swaylock = {};
        login = {
          gnupg.enable = true;
        };
      };
    };
  };
}
