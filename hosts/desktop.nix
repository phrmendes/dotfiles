{
  config,
  lib,
  parameters,
  pkgs,
  ...
}: {
  imports = [./shared];

  boot = {
    extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    kernelModules = ["kvm-amd" "snd-aloop" "v4l2loopback"];
    kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
    supportedFilesystems = ["btrfs" "ntfs"];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  networking.hostName = "desktop";
  programs.virt-manager.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };
    };
  };
}
