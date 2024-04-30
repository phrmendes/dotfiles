{
  lib,
  config,
  ...
}: {
  options.swaylock.enable = lib.mkEnableOption "enable swaylock";

  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = let
      colors = import ./catppuccin.nix;
    in {
      enable = true;
      settings = with colors.catppuccin.code; {
        daemonize = true;
        font = "Fira Sans";
        ignore-empty-password = true;
        indicator-caps-lock = true;
        scaling = "fill";
        show-failed-attempts = true;
        color = base;
        bs-hl-color = rosewater;
        caps-lock-bs-hl-color = rosewater;
        caps-lock-key-hl-color = green;
        inside-caps-lock-color = "00000000";
        inside-clear-color = "00000000";
        inside-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = green;
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = text;
        line-caps-lock-color = "00000000";
        line-clear-color = "00000000";
        line-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-caps-lock-color = peach;
        ring-clear-color = rosewater;
        ring-color = lavender;
        ring-ver-color = blue;
        ring-wrong-color = maroon;
        separator-color = "00000000";
        text-caps-lock-color = peach;
        text-clear-color = rosewater;
        text-color = text;
        text-ver-color = blue;
        text-wrong-color = maroon;
      };
    };
  };
}
