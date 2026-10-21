{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
