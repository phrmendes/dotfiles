{pkgs, ...}: {
  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq.enable = true;

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };

    fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-elan;
      };
    };
  };
}
