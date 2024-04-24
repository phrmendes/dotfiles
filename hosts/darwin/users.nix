{
  parameters,
  pkgs,
  ...
}: {
  users.users.${parameters.user} = {
    inherit (parameters) home;
    shell = pkgs.zsh;
  };
}
