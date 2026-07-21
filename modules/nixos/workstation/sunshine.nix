_: {
  modules.nixos.workstation.sunshine =
    _:
    {
      services.sunshine = {
        enable = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    };
}
