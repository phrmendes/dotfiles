{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../workstation ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "i915.enable_rc6=1"
      "i915.modeset=1"
      "mem_sleep_default=deep"
    ];
    extraModprobeConfig = lib.mkDefault ''
      options snd_hda_intel power_save=1
      options snd_ac97_codec power_save=1
      options iwlwifi power_save=Y
      options iwldvm force_cam=N
    '';
  };

  environment.systemPackages = with pkgs; [ powertop ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  networking.hostName = "laptop";

  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;

    auto-cpufreq = {
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

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        horizontalScrolling = true;
        disableWhileTyping = true;
      };
    };

    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "ignore";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
    };

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
  };
}
