{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.modules) homeManager;
  inherit (config.modules.nixos) server core;
  hostAddress = "10.250.0.1";
  localAddress = "10.250.0.2";
in
{
  modules.nixos.server.container = _: {
    boot.enableContainers = true;
    virtualisation.containers.enable = true;
    networking.firewall.allowedTCPPorts = [ 2222 ];

    systemd.services."container@dev" = {
      serviceConfig = {
        MemoryMax = "5G";
        CPUQuota = "400%";
      };
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp3s0";
      forwardPorts = [
        {
          sourcePort = 2222;
          destination = "${localAddress}:2222";
          proto = "tcp";
        }
      ];
    };

    containers.dev = {
      autoStart = true;
      privateNetwork = true;
      inherit hostAddress localAddress;

      enableTun = true;

      additionalCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_SYS_ADMIN"
      ];

      allowedDevices = [
        {
          modifier = "rw";
          node = "/dev/net/tun";
        }
        {
          modifier = "rw";
          node = "/dev/fuse";
        }
      ];

      bindMounts."${settings.home}/.ssh/age" = {
        hostPath = "/persist${settings.home}/.ssh/age";
        isReadOnly = true;
      };
      bindMounts."/mnt/external/pi" = {
        hostPath = "/mnt/external/pi";
        isReadOnly = false;
      };
      bindMounts."${settings.home}/.ssh/authorized_keys" = {
        hostPath = "/persist${settings.home}/.ssh/authorized_keys";
        isReadOnly = true;
      };

      config =
        { config, lib, ... }:
        {
          imports = [
            inputs.agenix.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            core.age
            core.home-manager
            core.machine
            core.nix-settings
            core.nixpkgs
            core.programs
            core.security
            core.services
            core.stylix
            core.users
            core.virtualisation
            server.age
            server.litellm
          ];

          age.identityPaths = [ "${settings.home}/.ssh/age" ];

          machine.type = "container";

          services.openssh.ports = [ 2222 ];

          home-manager.users.${settings.user}.imports =
            (with homeManager.user; [ base ])
            ++ (with homeManager.dev; [
              atuin
              bat
              btop
              direnv
              docker
              eza
              fd
              fzf
              gh
              git
              helix
              jq
              k8s
              lazydocker
              lazygit
              nix-index
              packages
              pi
              ripgrep
              starship
              tealdeer
              tmux
              yazi
              zoxide
              zsh
            ]);

          systemd.tmpfiles.rules = [
            "L+ /home/${settings.user}/.docker/config.json - - - - ${
              config.age.secrets."docker-config.json".path
            }"
            "L+ /home/${settings.user}/.config/gh/hosts.yml - - - - ${config.age.secrets."gh-hosts.yaml".path}"
            "L+ /home/${settings.user}/pi - - - - /mnt/external/pi"
          ];

          home-manager.sharedModules = [
            {
              programs.gh.settings = {
                git_protocol = "https";
                prompt = "enabled";
              };
            }
          ];

          networking = {
            useHostResolvConf = lib.mkForce false;
            defaultGateway = hostAddress;
          };

          services.resolved = {
            enable = true;
            settings.Resolve = {
              DNSSEC = "false";
              LLMNR = "false";
            };
          };

          system.stateVersion = "25.11";
        };
    };
  };
}
