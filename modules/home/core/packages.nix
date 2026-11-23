{ config, ... }:
{
  flake.modules.homeManager.sharedPackages = { pkgs, ... }: {
    home.packages = with pkgs; [
      android-tools
      docker-compose
      dux-gop
      gdu
      glab
      localsend
      nix-prefetch-github
      presenterm
      proton-vpn
      worktrunk
      local.gcp
    ];
  };

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
