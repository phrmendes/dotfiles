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

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        horizontalScrolling = true;
        disableWhileTyping = true;
      };
    };

    logind = {
      lidSwitch = "suspend";
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      lidSwitchExternalPower = "ignore";
    };

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };

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
      "documents" = {
        path = "${parameters.home}/Documents/documents";
        devices = ["desktop" "orangepizero2" "phone"];
        versioning = versioning.trashcan;
      };
      "images" = {
        path = "${parameters.home}/Pictures/images";
        devices = ["orangepizero2" "desktop"];
        versioning = versioning.trashcan;
      };
      "notes" = {
        path = "${parameters.home}/Documents/notes";
        devices = ["desktop" "orangepizero2" "phone" "tablet"];
        versioning = versioning.simple;
      };
      "ufabc" = {
        path = "${parameters.home}/Documents/ufabc";
        devices = ["desktop" "orangepizero2" "phone" "tablet"];
        versioning = versioning.trashcan;
      };
      "IT" = {
        path = "${parameters.home}/Documents/library/IT";
        devices = ["desktop" "orangepizero2"];
        versioning = versioning.trashcan;
      };
      "math" = {
        path = "${parameters.home}/Documents/library/math";
        devices = ["desktop" "orangepizero2"];
        versioning = versioning.trashcan;
      };
      "social_sciences" = {
        path = "${parameters.home}/Documents/library/social_sciences";
        devices = ["desktop" "orangepizero2"];
        versioning = versioning.trashcan;
      };
      "zotero" = {
        path = "${parameters.home}/Documents/library/zotero";
        devices = ["desktop" "orangepizero2" "phone" "tablet"];
        versioning = versioning.trashcan;
      };
    };
  };
}
