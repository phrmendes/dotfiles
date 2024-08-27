{
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

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
  };
}
