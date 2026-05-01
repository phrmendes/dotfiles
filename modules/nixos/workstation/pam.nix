_: {
  modules.nixos.workstation.pam = {
    security.pam.services = {
      login.gnupg.enable = true;
    };
  };
}
