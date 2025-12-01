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
    ./systemd.nix
  ];

  boot.kernelModules = [
    "ip_tables"
    "ip6_tables"
  ];

  age.secrets = {
    "docker-compose.env" = {
      file = ../../secrets/docker-compose.env.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    "transmission.json" = {
      file = ../../secrets/transmission.json.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    "prunemate.json" = {
      file = ../../secrets/prunemate.json.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    "dozzle-users.yaml" = {
      file = ../../secrets/dozzle-users.yaml.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
  programs.nh.flake = "/home/${parameters.user}/dotfiles";
  networking.hostName = "server";

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
      extraUpFlags = [ "--advertise-tags=tag:main" ];
      extraSetFlags = [
        "--advertise-exit-node"
        "--accept-routes"
        "--advertise-routes=192.168.0.0/24"
      ];
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
