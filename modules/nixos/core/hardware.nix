_: {
  modules.nixos.core.hardware =
    {
      modulesPath,
      config,
      lib,
      ...
    }:
    let
      inherit (config.machine) isWorkstation isContainer;
    in
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      hardware = {
        keyboard.qmk = lib.mkIf isWorkstation {
          enable = true;
        };
        enableAllFirmware = !isContainer;
        uinput.enable = !isContainer;

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
}
