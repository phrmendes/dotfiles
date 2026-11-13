{ config, inputs, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.shell =
    { lib, pkgs, ... }:
    let
      agenix = inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      aliases = {
        a = "${lib.getExe pkgs.atuin} scripts run";
        cat = lib.getExe pkgs.bat;
        create-secret = "${lib.getExe pkgs.authelia} crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986";
        k = lib.getExe pkgs.kubectl;
        open-secret = "${lib.getExe' agenix "agenix"} -i ~/.ssh/age -e";
        unlock-server = "ssh server-unlock";
        v = "nvim";
        wake-server = "${lib.getExe pkgs.wakeonlan} ${settings.lan.serverMac}";
      };
    in
    {
      programs = {
        bash = {
          shellAliases = aliases;
          initExtra = ''
            export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
            export DOCKER_SOCK="$XDG_RUNTIME_DIR/podman/podman.sock"
          '';
        };
        nushell = {
          shellAliases = aliases;
          environmentVariables = {
            DOCKER_HOST = lib.hm.nushell.mkNushellInline ''$"unix://($env.XDG_RUNTIME_DIR)/podman/podman.sock"'';
            DOCKER_SOCK = lib.hm.nushell.mkNushellInline ''$"($env.XDG_RUNTIME_DIR)/podman/podman.sock"'';
          };
        };
      };
    };
}
