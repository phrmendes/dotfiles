_: {
  modules.homeManager.dev.docker =
    { pkgs, lib, ... }:
    let
      configDrv = pkgs.writeText "docker-config.json" (
        builtins.toJSON {
          credsStore = "secretservice";
        }
      );
    in
    {
      home.packages = with pkgs; [
        docker-buildx
        docker-compose
      ];

      home.activation.dockerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        config="$HOME/.docker/config.json"
        $DRY_RUN_CMD mkdir -p "$(dirname "$config")"
        $DRY_RUN_CMD cp ${configDrv} "$config"
        $DRY_RUN_CMD chmod 600 "$config"
      '';
    };
}
