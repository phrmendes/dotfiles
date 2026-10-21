{
  flake.modules.nixos.sunshine =
    { lib, ... }:
    {
      services.sunshine = {
        enable = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      systemd.user.services.sunshine.serviceConfig = {
        Restart = lib.mkForce "always";
        RestartSec = "5s";
      };
    };
}
