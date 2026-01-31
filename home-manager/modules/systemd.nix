{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.systemd.enable = lib.mkEnableOption "enable systemd";

  config = lib.mkIf config.systemd.enable {
    systemd.user = {
      services.nvim-lsp-log-cleanup = {
        Unit = {
          Description = "Clean up Neovim LSP log files";
          Documentation = [ "https://neovim.io/" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/rm -f %h/.local/state/nvim/lsp.log";
        };
      };

      timers.nvim-lsp-log-cleanup = {
        Unit = {
          Description = "Daily cleanup of Neovim LSP logs";
          Requires = "nvim-lsp-log-cleanup.service";
        };
        Timer = {
          OnCalendar = "*-*-* 11:00";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
