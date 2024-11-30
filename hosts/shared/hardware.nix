{
  lib,
  modulesPath,
  parameters,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault parameters.system;

  hardware = {
    enableAllFirmware = true;
    uinput.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
