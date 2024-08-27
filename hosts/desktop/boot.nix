{config, ...}: {
  boot = {
    supportedFilesystems = ["btrfs" "ntfs"];
    kernelModules = ["kvm-amd" "snd-aloop" "v4l2loopback"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';

    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
  };
}
