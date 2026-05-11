{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.neovim-server =
    { config, lib, ... }:
    let
      neovim = config.programs.neovim.finalPackage;
    in
    {
      systemd.services.neovim-server = {
        description = "Neovim headless server";
        documentation = [ "https://neovim.io/" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = settings.user;
          ExecStart = "${lib.getExe neovim} --headless --listen 0.0.0.0:${toString settings.nvimServerPort}";
          Restart = "always";
          RestartSec = 5;
          WorkingDirectory = settings.home;
        };
      };
    };
}
