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

  services = {
    xserver.videoDrivers = ["nvidia"];

    syncthing = {
      settings = {
        folders = let
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
            devices = ["phone" "orangepizero2"];
            versioning = versioning.trashcan;
          };
          "documents" = {
            path = "${parameters.home}/Documents/documents";
            devices = ["phone" "orangepizero2" "laptop"];
            versioning = versioning.trashcan;
          };
          "images" = {
            path = "${parameters.home}/Pictures/images";
            devices = ["orangepizero2" "laptop"];
            versioning = versioning.trashcan;
          };
          "notes" = {
            path = "${parameters.home}/Documents/notes";
            devices = ["phone" "tablet" "orangepizero2" "laptop"];
            versioning = versioning.simple;
          };
          "ufabc" = {
            path = "${parameters.home}/Documents/ufabc";
            devices = ["orangepizero2" "tablet" "laptop"];
            versioning = versioning.trashcan;
          };
          "comics" = {
            path = "${parameters.home}/Documents/library/comics";
            devices = ["orangepizero2"];
            versioning = versioning.trashcan;
          };
          "IT" = {
            path = "${parameters.home}/Documents/library/IT";
            devices = ["orangepizero2" "laptop"];
            versioning = versioning.trashcan;
          };
          "math" = {
            path = "${parameters.home}/Documents/library/math";
            devices = ["orangepizero2" "laptop"];
            versioning = versioning.trashcan;
          };
          "social_sciences" = {
            path = "${parameters.home}/Documents/library/social_sciences";
            devices = ["orangepizero2" "laptop"];
            versioning = versioning.trashcan;
          };
          "zotero" = {
            path = "${parameters.home}/Documents/library/zotero";
            devices = ["phone" "orangepizero2" "tablet" "laptop"];
            versioning = versioning.trashcan;
          };
        };
        devices = {
          "phone" = {
            id = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
            autoAcceptFolders = true;
          };
          "tablet" = {
            id = "ME77KQY-MGUM34F-M6RI4DI-EPNNS2P-FSPEYB6-2XUHYZB-5MGG7BV-XJTGAQO";
            autoAcceptFolders = true;
          };
          "orangepizero2" = {
            id = "LERY5VL-SZREUIC-2ZQ2JKC-SB5XM3E-SMRMI3J-SUD54AQ-HDCHA46-AUOF6QK";
            autoAcceptFolders = true;
          };
          "laptop" = {
            id = "DC7CVQK-XCQYE7F-JTW2JNJ-PQRSZOV-WU5GK5H-DZNX5VM-PU4HIKL-ZJUA5AX";
            autoAcceptFolders = true;
          };
        };
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
