{
  config,
  lib,
  parameters,
  ...
}:
{
  imports = [ ./workstation.nix ];

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

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.persistence."/persist".users.${parameters.user}.directories = [ ".sops" ];
}
