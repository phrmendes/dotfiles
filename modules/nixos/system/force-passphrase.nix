{
  flake.modules.nixos.forcePassphrase =
    { config, pkgs, ... }:
    let
      stamp = "luks-passphrase-stamp";
      hours = 48;
    in
    {
      boot.initrd = {
        availableKernelModules = [
          "vfat"
          "nls_cp437"
          "nls_iso8859-1"
        ];
        systemd = {
          extraBin.tpm2_pcrextend = "${pkgs.tpm2-tools}/bin/tpm2_pcrextend";
          services.force-passphrase = {
            description = "Turn the TPM PIN off for one boot when the passphrase is due";
            wantedBy = [ "initrd.target" ];
            before = [ "systemd-cryptsetup@crypted.service" ];
            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              TimeoutStartSec = 30;
            };
            environment = {
              ESP = config.fileSystems."/boot".device;
              STAMP = stamp;
              INTERVAL = toString (hours * 3600);
              POISON = builtins.hashString "sha256" "force-passphrase";
              TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
            };
            script = builtins.readFile ../../../files/scripts/force-passphrase.sh;
          };
        };
      };

      systemd.services.record-passphrase-boot = {
        description = "Record the time of a boot that asked for the passphrase";
        wantedBy = [ "multi-user.target" ];
        requires = [ "boot.mount" ];
        after = [ "boot.mount" ];
        unitConfig.ConditionPathExists = "/run/passphrase-forced";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = "date +%s > /boot/${stamp}";
      };
    };
}
