{ config, pkgs, ... }:

let
  user = "prochame";
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  imports = [ ./home.nix ];
  users.users.${user} = {
    home = "/Users/${user}";
    description = "Pedro Mendes";
    shell = pkgs.bash;
  };
  nixpkgs.config.allowUnfree = true;
  environment = {
    pathsToLink = [ "/share/fish" ];
    systemPackages = with pkgs; [
      zip
      curl
      unzip
      unrar
      tree
      git
      gzip
      vim
      home-manager
    ];
  };
  fonts = {
     enableFontDir = true;
     fonts = [ "nerdfonts" ];
  };
  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "right";
        showhidden = true;
        mru-spaces = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };
    };
  };
}
