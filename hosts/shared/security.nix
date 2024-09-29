{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = true;
    pam = {
      services = {
        login = {
          gnupg.enable = true;
        };
      };
    };
  };
}
