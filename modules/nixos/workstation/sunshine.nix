_: {
  modules.nixos.workstation.sunshine =
    { ... }:
    {
      services.sunshine = {
        enable = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    };
}
