{
  inputs,
  parameters,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "old";
    extraSpecialArgs = { inherit inputs parameters; };
    users.${parameters.user} = {
      imports = [ ../../modules ];
    };
  };
}
