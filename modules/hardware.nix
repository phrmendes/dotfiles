_: {
  modules.nixos.core = {
    hardware =
      {
        modulesPath,
        config,
        lib,
        ...
      }:
      let
        inherit (config.machine) isWorkstation;
        isNotContainer = config.machine.type != "container";
      in
      {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        hardware = {
          keyboard.qmk = lib.mkIf isWorkstation {
            enable = true;
          };
          enableAllFirmware = isNotContainer;
          uinput.enable = isNotContainer;

          bluetooth = lib.mkIf isWorkstation {
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
          LC_MONETARY = "pt_BR.UTF-8";
          LC_MEASUREMENT = "pt_BR.UTF-8";
          LC_NUMERIC = "pt_BR.UTF-8";
        };
      };
    };
  };
}
