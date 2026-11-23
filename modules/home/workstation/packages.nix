{ config, ... }:
{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    imports = [ config.flake.modules.homeManager.sharedPackages ];

    home.packages =
      (with pkgs; [
        file-roller
        fragments
        gcolor3
        gnome-disk-utility
        libqalculate
        lima
        loupe
        pavucontrol
        wl-clipboard
        xre
      ])
      ++ (with pkgs.local; [
        diff-persist
        noctalia-settings-diff
        pin
        screenshot
      ]);
  };
}
