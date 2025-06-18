{ parameters, ... }:
{
  age.identityPaths = [ "/persist/${parameters.home}/.ssh/id_ed25519" ];
}
