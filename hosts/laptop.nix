{
  config,
  lib,
  parameters,
  pkgs,
  ...
}: {
  imports = [./shared];

  boot = {
    kernelModules = ["kvm-intel"];
    kernelParams = ["i915.enable_rc6=1" "i915.modeset=1" "mem_sleep_default=deep"];
    extraModprobeConfig = lib.mkDefault ''
      options snd_hda_intel power_save=1
      options snd_ac97_codec power_save=1
      options iwlwifi power_save=Y
      options iwldvm force_cam=N
    '';
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
    sensor.iio.enable = true;
  };

  networking.hostName = "laptop";

  environment = {
    systemPackages = with pkgs; [powertop];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };

  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          energy_performance_preference = "power";
          turbo = "never";
        };
      };
    };

    logind = {
      lidSwitch = "suspend";
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      lidSwitchExternalPower = "ignore";
    };

    syncthing = {
      settings = {
        folders = {
          "documents" = {
            path = "${parameters.home}/Documents/documents";
            devices = ["phone" "server" "desktop"];
          };
          "images" = {
            path = "${parameters.home}/Pictures/images";
            devices = ["server" "desktop"];
          };
          "notes" = {
            path = "${parameters.home}/Documents/notes";
            devices = ["phone" "tablet" "server" "desktop"];
          };
          "ufabc" = {
            path = "${parameters.home}/Documents/ufabc";
            devices = ["server" "tablet" "desktop"];
          };
          "IT" = {
            path = "${parameters.home}/Documents/library/IT";
            devices = ["server" "desktop"];
          };
          "math" = {
            path = "${parameters.home}/Documents/library/math";
            devices = ["server" "desktop"];
          };
          "social_sciences" = {
            path = "${parameters.home}/Documents/library/social_sciences";
            devices = ["server" "desktop"];
          };
          "zotero" = {
            path = "${parameters.home}/Documents/library/zotero";
            devices = ["phone" "server" "tablet" "desktop"];
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
          "server" = {
            id = "VH6IWI6-D5E666H-4S2D7XJ-AVHD2XW-7UC64AS-APTOCPU-LB3SB52-S5722Q5";
            autoAcceptFolders = true;
          };
          "desktop" = {
            id = "2BIXHD4-5LMQH5L-PNJC6JP-FQ5JVTP-HWUJM63-FO6PE5Z-AF6RYNF-SWDZHAW";
            autoAcceptFolders = true;
          };
        };
      };
    };

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
  };
}
