{
  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq.enable = true;

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };

    fprintd.enable = true;
  };
}
