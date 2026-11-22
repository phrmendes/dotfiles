{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages =
      (with pkgs; [
        android-tools
        docker-compose
        dux-gop
        file-roller
        fragments
        gcolor3
        gdu
        glab
        gnome-disk-utility
        libqalculate
        lima
        localsend
        loupe
        nix-prefetch-github
        pavucontrol
        presenterm
        proton-vpn
        wl-clipboard
        worktrunk
        xre
      ])
      ++ (with pkgs.local; [
        diff-persist
        gcp
        noctalia-settings-diff
        pin
        screenshot
      ]);
  };
}
