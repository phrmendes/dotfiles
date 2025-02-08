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
    };
  };
}
