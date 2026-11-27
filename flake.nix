{
  description = "My personal NixOS configuration";

  outputs =
    { self, ... }:
    let
      inputs = (import ./.tack) // {
        inherit self;
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        (inputs.import-tree ./modules)
        (inputs.import-tree ./hosts)
      ];
    };
}
