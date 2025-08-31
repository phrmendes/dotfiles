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

  boot.kernelModules = [
    "ip_tables"
    "ip6_tables"
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
  programs.nh.flake = "/home/${parameters.user}/dotfiles";

  networking = {
    hostName = "server";
    nftables.enable = true;
    networkmanager.dns = "systemd-resolved";
  };

  environment = {
    systemPackages = with pkgs; [
      gh
      just
      lazyjournal
      neovim
      python313
    ];

    persistence."/persist".users.${parameters.user}.directories = [
      "dotfiles"
      ".config"
      ".ssh"
      ".local/share"
      ".local/state"
    ];
  };

  fileSystems = {
    "/mnt/external" = {
      device = "/dev/disk/by-label/external";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  };

  services = {
    xserver.displayManager.lightdm.enable = false;

    tailscale = {
      useRoutingFeatures = "both";
      extraUpFlags = [ "--advertise-tags=tags:main" ];
      extraSetFlags = [ "--advertise-exit-node" ];
    };
  };

  home-manager.users.${parameters.user} = {
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;

    xdg.configFile."nvim/init.lua".source = ../../dotfiles/neovim.lua;
  };
}
