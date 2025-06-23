{
  pkgs,
  config,
  lib,
  parameters,
  ...
}:
{
  imports = [
    ../shared
    ./age.nix
    ./systemd.nix
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
  networking.hostName = "server";
  users.users.${parameters.user}.shell = pkgs.fish;

  programs = {
    nh.flake = "/home/${parameters.user}/dotfiles";
    fish.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    tmux = {
      enable = true;
      newSession = true;
      aggressiveResize = true;
      escapeTime = 0;
      keyMode = "vi";
      extraConfig = lib.fileContents ../../dotfiles/tmux.conf;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      configure.customRC = lib.fileContents ../../dotfiles/init.vim;
    };
  };

  environment.systemPackages = with pkgs; [ python313 ];

  services = {
    xserver.displayManager.lightdm.enable = false;
    tailscale = {
      useRoutingFeatures = "both";
      extraUpFlags = [ "--advertise-tags=tags:main" ];
      extraSetFlags = [ "--advertise-exit-node" ];
    };
  };

  environment = {
    persistence."/persist".users.${parameters.user}.directories = [
      "dotfiles"
      ".config"
      ".ssh"
      ".zotero"
      ".local/share"
      ".local/state"
    ];
    etc = {
      "compose/init.sh" = {
        source = ../../dotfiles/compose/init.sh;
        mode = "0644";
      };
      "compose/docker-compose.yaml" = {
        source = ../../dotfiles/compose/docker-compose.yaml;
        mode = "0644";
      };
    };
  };

  fileSystems = {
    "/mnt/external" = {
      device = "/dev/disk/by-label/external";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  };

  home-manager.users.${parameters.user} = {
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };
}
