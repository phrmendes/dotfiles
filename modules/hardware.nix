_: {
  modules.nixos.core = {
    hardware =
      { modulesPath, ... }:
      {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        hardware = {
          keyboard.qmk.enable = true;
          enableAllFirmware = true;
          uinput.enable = true;

          bluetooth = {
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
