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
  programs.nh.flake = "/home/${parameters.user}/dotfiles";

  environment.systemPackages = with pkgs; [
    gh
    helix
    just
    lazydocker
    python313
  ];

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

  home-manager.users.${parameters.user} = {
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    tmux.enable = true;
    zoxide.enable = true;
  };
}
