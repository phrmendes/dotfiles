{
  config,
  inputs,
  ...
}:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos.core =
    {
      lib,
      modulesPath,
      ...
    }:
    let
      utils = import ../../utils { inherit lib; };
    in
    {
      options.utils = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        readOnly = true;
        default = utils;
      };

      imports = [
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.impermanence.nixosModules.impermanence
        (modulesPath + "/installer/scan/not-detected.nix")
      ]
      ++ (with nixos; [
        boot
        nix
        openssh
        stylix
        system
        users
      ]);
    };
}
