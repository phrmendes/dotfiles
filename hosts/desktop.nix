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

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${parameters.user}/.steam/root/compatibilitytools.d";
  };

  networking.hostName = "desktop";

  programs = {
    virt-manager.enable = true;
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
    syncthing.settings.folders = let
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
    in {
      "camera" = {
        path = "${parameters.home}/Pictures/camera";
        devices = ["orangepizero2" "phone"];
        versioning = versioning.trashcan;
      };
      "documents" = {
        path = "${parameters.home}/Documents/documents";
        devices = ["laptop" "orangepizero2" "phone"];
        versioning = versioning.trashcan;
      };
      "images" = {
        path = "${parameters.home}/Pictures/images";
        devices = ["orangepizero2" "laptop"];
        versioning = versioning.trashcan;
      };
      "notes" = {
        path = "${parameters.home}/Documents/notes";
        devices = ["laptop" "orangepizero2" "phone" "tablet"];
        versioning = versioning.simple;
      };
      "ufabc" = {
        path = "${parameters.home}/Documents/ufabc";
        devices = ["laptop" "orangepizero2" "phone" "tablet"];
        versioning = versioning.trashcan;
      };
      "comics" = {
        path = "${parameters.home}/Documents/library/comics";
        devices = ["orangepizero2"];
        versioning = versioning.trashcan;
      };
      "IT" = {
        path = "${parameters.home}/Documents/library/IT";
        devices = ["laptop" "orangepizero2"];
        versioning = versioning.trashcan;
      };
      "math" = {
        path = "${parameters.home}/Documents/library/math";
        devices = ["laptop" "orangepizero2"];
        versioning = versioning.trashcan;
      };
      "social_sciences" = {
        path = "${parameters.home}/Documents/library/social_sciences";
        devices = ["laptop" "orangepizero2"];
        versioning = versioning.trashcan;
      };
      "zotero" = {
        path = "${parameters.home}/Documents/library/zotero";
        devices = ["laptop" "orangepizero2" "phone" "tablet"];
        versioning = versioning.trashcan;
      };
      "collections" = {
        path = "${parameters.home}/Documents/collections";
        devices = ["laptop" "orangepizero2"];
        versioning = versioning.trashcan;
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
          })
          .fd
        ];
      };
    };
  };
}
