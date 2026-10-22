{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
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
}
