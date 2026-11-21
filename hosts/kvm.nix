{ config, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.kvm.module =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/sd-card/sd-image.nix")
        nixos.openssh
        nixos.pikvm
      ];

      nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
      system.stateVersion = settings.stateVersion;

      boot = {
        loader.grub.enable = false;
        loader.generic-extlinux-compatible.enable = true;
        loader.generic-extlinux-compatible.configurationLimit = settings.generations;
        kernelParams = [ "console=ttyS0,115200n8" ];
        initrd.availableKernelModules = [ "mmc_block" ];
        tmp.useTmpfs = true;
      };
      hardware = {
        enableAllHardware = lib.mkForce false;
        deviceTree = {
          enable = true;
          name = "allwinner/sun50i-h616-orangepi-zero2.dtb";
        };
      };

      sdImage = {
        populateFirmwareCommands = "";
        populateRootCommands = ''
          mkdir -p ./files/boot
          ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
        '';
        postBuildCommands = ''
          dd if=${pkgs.ubootOrangePiZero2}/u-boot-sunxi-with-spl.bin of="$img" bs=1024 seek=8 conv=notrunc
        '';
      };

      networking = {
        hostName = "kvm";
        useDHCP = false;
        useNetworkd = true;
      };
      systemd.network.networks."10-lan" = {
        matchConfig.Name = "end0 eth0";
        address = [ "${settings.lan.kvmAddress}/24" ];
        gateway = [ "192.168.10.1" ];
        dns = [ "192.168.10.1" ];
      };
      services.avahi = {
        enable = true;
        settings.publish = {
          disable-publishing = false;
          publish-addresses = true;
        };
      };

      users.users.${settings.user} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = map builtins.readFile [
          ../files/ssh/desktop.txt
          ../files/ssh/laptop.txt
          ../files/ssh/phone.txt
        ];
      };
      security.sudo.wheelNeedsPassword = false;
      security.pki.certificateFiles = [ ../files/ca.crt ];

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        trusted-users = [ "@wheel" ];
        max-jobs = 1;
        cores = 1;
      };
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      zramSwap.enable = true;
      services.journald.settings.Journal.SystemMaxUse = "64M";
      documentation.enable = false;
    };
}
