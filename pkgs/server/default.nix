{ pkgs }:
{
  wait-for-age-secrets = pkgs.callPackage ./wait-for-age-secrets.nix { };
  wait-for-docker-socket = pkgs.callPackage ./wait-for-docker-socket.nix { };
}
