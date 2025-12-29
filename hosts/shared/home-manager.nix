{
  inputs,
  parameters,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs parameters; };
    users.${parameters.user} = {
      imports = [ ../../hm ];
    };
  };
}
