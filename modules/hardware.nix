_: {
  modules.nixos.core = {
    hardware =
      {
        modulesPath,
        config,
        lib,
        ...
      }:
      {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        hardware = {
          keyboard.qmk = lib.mkIf (config.machine.type != "server" && config.machine.type != "container") {
            enable = true;
          };
          enableAllFirmware = lib.mkIf (config.machine.type != "container") true;
          uinput.enable = lib.mkIf (config.machine.type != "container") true;

          bluetooth = lib.mkIf (config.machine.type != "server" && config.machine.type != "container") {
            enable = true;
            powerOnBoot = true;
            settings.Policy.AutoEnable = true;
            input.General = {
              ClassicBondedOnly = false;
              LEBondedOnly = false;
              UserspaceHID = true;
            };
          };
        };
      };

    i18n = {
      time.timeZone = "America/Sao_Paulo";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_MONETARY = "pt_BR.UTF8";
          LC_MEASUREMENT = "pt_BR.UTF8";
          LC_NUMERIC = "pt_BR.UTF8";
        };
      };
    };
  };
}
