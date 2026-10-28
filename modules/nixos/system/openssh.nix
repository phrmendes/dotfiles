_: {
  flake.modules.nixos.openssh = {
    services.openssh = {
      allowSFTP = true;
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        PubKeyAuthentication = true;
      };
    };

  };
}
