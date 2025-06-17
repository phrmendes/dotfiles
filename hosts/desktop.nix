{
  config,
  lib,
  parameters,
  pkgs,
  ...
}:
{
  imports = [ ./shared ];

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
    supportedFilesystems = [
      "btrfs"
      "ntfs"
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

  programs.virt-manager.enable = true;

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    syncthing.settings.folders =
      let
        versioning = {
          simple = {
            type = "simple";
            params = {
              keep = "10";
              cleanoutDays = "30";
            };
          };
          trashcan = {
            type = "trashcan";
            params.cleanoutDays = "15";
          };
        };
      in
      {
        "camera" = {
          path = "${parameters.home}/Pictures/camera";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "phone"
          ];
        };
        "documents" = {
          path = "${parameters.home}/Documents/documents";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "images" = {
          path = "${parameters.home}/Pictures/images";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "notes" = {
          path = "${parameters.home}/Documents/notes";
          versioning = versioning.simple;
          devices = [
            "server"
            "phone"
            "tablet"
          ];
        };
        "ufabc" = {
          path = "${parameters.home}/Documents/ufabc";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "comics" = {
          path = "${parameters.home}/Documents/library/comics";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "IT" = {
          path = "${parameters.home}/Documents/library/IT";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "math" = {
          path = "${parameters.home}/Documents/library/math";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "social_sciences" = {
          path = "${parameters.home}/Documents/library/social_sciences";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "zotero" = {
          path = "${parameters.home}/Documents/library/zotero";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "tablet"
          ];
        };
        "collections" = {
          path = "${parameters.home}/Documents/collections";
          versioning = versioning.trashcan;
          devices = [ "server" ];
        };
        "keepassxc" = {
          path = "${parameters.home}/Documents/keepassxc";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "phone"
          ];
        };
      };
  };

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
          }).fd
        ];
      };
    };
  };
}
