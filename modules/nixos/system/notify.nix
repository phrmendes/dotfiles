{
  flake.modules.nixos.notify =
    { config, lib, ... }:
    {
      options.notifyOnFailure = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Units that report through a notify-failure-<unit> reporter when they fail.";
      };

      config.systemd.services =
        lib.listToAttrs (
          map (unit: {
            name = "notify-failure-${unit}";
            value = {
              description = "Report a failure of ${unit}";
              script = "echo '${unit} failed at' $(date -Is) >&2";
              serviceConfig.Type = "oneshot";
            };
          }) config.notifyOnFailure
        )
        // lib.listToAttrs (
          map (unit: {
            name = unit;
            value.unitConfig.OnFailure = [ "notify-failure-${unit}.service" ];
          }) config.notifyOnFailure
        );
    };
}
