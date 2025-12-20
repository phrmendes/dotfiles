{
  config,
  lib,
  parameters,
  ...
}:
{
  imports = [ ../workstation ];

  boot = {
    extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
      config.boot.kernelPackages.nvidia_x11
    ];
    kernelModules = [
      "kvm-amd"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
      "snd-aloop"
      "v4l2loopback"
    ];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
  };

  hardware = {
    xpadneo.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
    nvidia-container-toolkit.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  swapDevices = [
    {
      device = "/persist/swapfile";
      size = 8192;
    }
  ];

  networking.hostName = "desktop";

  programs = {
    gamemode.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.persistence."/persist".users.${parameters.user}.directories = [
    ".steam"
    ".sops"
  ];

  fileSystems = {
    "/mnt/small" = {
      device = "/dev/disk/by-label/small";
      fsType = "ext4";
      options = [ "defaults" ];
    };
    "/mnt/big" = {
      device = "/dev/disk/by-label/big";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/big 0755 ${parameters.user} users - -"
    "d /mnt/small 0755 ${parameters.user} users - -"
  ];
}
