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
}
