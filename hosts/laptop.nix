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

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
  };
}
