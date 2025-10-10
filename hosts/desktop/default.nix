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
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
    kernelModules = [
      "kvm-amd"
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
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  networking.hostName = "desktop";

  programs = {
    droidcam.enable = true;
    gamemode.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.persistence."/persist".users.${parameters.user}.directories = [ ".steam" ];

  home-manager.users.${parameters.user} = {
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "${parameters.home}/.steam/root/compatibilitytools.d";
    };
  };
}
