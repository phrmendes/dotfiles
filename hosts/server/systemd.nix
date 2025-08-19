{
  pkgs,
  parameters,
  config,
  ...
}:
{
  systemd = {
    tmpfiles.rules = [
      "d /mnt/external 2775 1000 1000 -"
      "d /mnt/external/downloads 2775 1000 1000 -"
      "d /mnt/external/downloads/.incomplete 2775 1000 1000 -"
      "d /mnt/external/movies 2775 1000 1000 -"
      "d /mnt/external/tvshows 2775 1000 1000 -"
      "d /var/lib/docker/volumes 2775 1000 1000 -"
    ];
    paths = {
      nixos-rebuild-switch = {
        pathConfig = {
          PathChanged = "${parameters.home}/dotfiles/secrets";
          Unit = "nixos-rebuild-switch.service";
        };
      };
    };
    services = {
      neovimd = {
        description = "Neovim daemon service";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.neovim}/bin/nvim --headless --listen 0.0.0.0:9000 -u ${parameters.home}/dotfiles/dotfiles/neovim.lua";
          Restart = "always";
          RestartSec = 2;
          User = parameters.user;
          WorkingDirectory = "${parameters.home}";
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };
      nixos-rebuild-switch = {
        description = "NixOS rebuild switch service";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStart = ''
            ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${parameters.home}/dotfiles#${config.networking.hostName}
          '';
        };
      };
    };
  };
}
