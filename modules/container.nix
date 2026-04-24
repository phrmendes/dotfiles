{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.modules) homeManager;
  inherit (config.modules.nixos) server core;
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

    networking.bridges."br-dev".interfaces = [ ];
    networking.interfaces."br-dev".ipv4.addresses = [
      {
        address = "10.250.0.1";
        prefixLength = 24;
      }
    ];

    networking.nat = {
      enable = true;
      internalInterfaces = [ "br-dev" ];
      externalInterface = "tailscale0";
      forwardPorts = [
        {
          sourcePort = 2222;
          destination = "10.250.0.10:2222";
          proto = "tcp";
        }
      ];
    };

    networking.firewall.extraCommands = ''
      iptables -t nat -A POSTROUTING -s 10.250.0.0/24 -o tailscale0 -j MASQUERADE
    '';

    containers.dev = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br-dev";
      localAddress = "10.250.0.10/24";
      localAddress6 = "fc00::10/64";

      enableTun = true;

      additionalCapabilities = [
        "CAP_NET_ADMIN"
      ];

      allowedDevices = [
        {
          modifier = "rw";
          node = "/dev/net/tun";
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
        {
          config,
          lib,
          ...
        }:
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

          services = {
            openssh = {
              enable = true;
              ports = [ 2222 ];
            };
            tailscale = {
              enable = true;
              authKeyFile = config.age.secrets.tailscale-authkey.path;
              authKeyParameters = {
                ephemeral = false;
                preauthorized = true;
              };
              useRoutingFeatures = "client";
              extraUpFlags = [ "--advertise-tags=tag:main" ];
            };
          };

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
            defaultGateway = "10.250.0.1";
            nameservers = [
              "100.100.100.100"
              "1.1.1.1"
              "8.8.8.8"
            ];
            interfaces.eth0.ipv4.routes = [
              {
                address = "0.0.0.0";
                prefixLength = 0;
                via = "10.250.0.1";
              }
            ];
          };

          services.resolved.enable = false;
          system.stateVersion = "25.05";
        };
    };
  };
}
