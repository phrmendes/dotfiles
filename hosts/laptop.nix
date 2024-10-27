{
  config,
  inputs,
  lib,
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ./shared
    inputs.auto-cpufreq.nixosModules.default
  ];

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
  };

  programs.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };

  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    fprintd.enable = true;

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
            devices = ["phone" "orangepizero2" "desktop"];
          };
          "images" = {
            path = "${parameters.home}/Pictures/images";
            devices = ["orangepizero2" "desktop"];
          };
          "notes" = {
            path = "${parameters.home}/Documents/notes";
            devices = ["phone" "tablet" "orangepizero2" "desktop"];
          };
          "ufabc" = {
            path = "${parameters.home}/Documents/ufabc";
            devices = ["orangepizero2" "tablet" "desktop"];
          };
          "IT" = {
            path = "${parameters.home}/Documents/library/IT";
            devices = ["orangepizero2" "desktop"];
          };
          "math" = {
            path = "${parameters.home}/Documents/library/math";
            devices = ["orangepizero2" "desktop"];
          };
          "social_sciences" = {
            path = "${parameters.home}/Documents/library/social_sciences";
            devices = ["orangepizero2" "desktop"];
          };
          "zotero" = {
            path = "${parameters.home}/Documents/library/zotero";
            devices = ["phone" "orangepizero2" "tablet" "desktop"];
          };
          "tmuxp" = {
            path = "${parameters.home}/.config/tmuxp";
            devices = ["orangepizero2" "desktop"];
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
