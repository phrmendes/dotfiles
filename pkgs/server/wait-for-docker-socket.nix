{ writeShellApplication }:
writeShellApplication {
  name = "wait-for-docker-socket";
  text = ''
    until [ -S /run/docker.sock ]; do sleep 1; done
  '';
}
