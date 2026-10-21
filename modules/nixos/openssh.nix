_:
{
  flake.modules.nixos.openssh = _: {
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
