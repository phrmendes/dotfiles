{
  inputs,
  parameters,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs parameters; };
    users.${parameters.user} = {
      imports = [ ../../modules ];
    };
  };
}
