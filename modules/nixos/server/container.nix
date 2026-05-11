{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.modules) homeManager;
  inherit (config.modules.nixos) server core;
  lan = settings.lan;
in
{
  modules.nixos.server.container = _: {
    boot.enableContainers = true;
    virtualisation.containers.enable = true;
    networking.firewall.allowedTCPPorts = [
      2222
      settings.nvimServerPort
    ];

    systemd.services."container@dev" = {
      serviceConfig = {
        MemoryMax = "5G";
        CPUQuota = "400%";
      };
    };

    boot.kernel.sysctl."net.ipv4.conf.all.route_localnet" = 1;

    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = lan.interface;
      forwardPorts = [
        {
          sourcePort = 2222;
          destination = "${lan.containerLocalAddress}:2222";
          proto = "tcp";
        }
        {
          sourcePort = settings.nvimServerPort;
          destination = "${lan.containerLocalAddress}:${toString settings.nvimServerPort}";
          loopbackIPs = [ lan.serverAddress ];
          proto = "tcp";
        }
      ];

      extraCommands = ''
        iptables -t nat -A nixos-nat-pre -i tailscale0 -p tcp --dport ${toString settings.nvimServerPort} \
          -j DNAT --to-destination ${lan.containerLocalAddress}:${toString settings.nvimServerPort}
      '';

      extraStopCommands = ''
        iptables -t nat -D nixos-nat-pre -i tailscale0 -p tcp --dport ${toString settings.nvimServerPort} \
          -j DNAT --to-destination ${lan.containerLocalAddress}:${toString settings.nvimServerPort} 2>/dev/null || true
      '';
    };

    containers.dev = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = lan.containerHostAddress;
      localAddress = lan.containerLocalAddress;

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

      bindMounts."${settings.home}/Projects" = {
        hostPath = "/mnt/external/pi";
        isReadOnly = false;
      };

      bindMounts."${settings.home}/dotfiles" = {
        hostPath = "/mnt/external/pi/dotfiles";
        isReadOnly = false;
      };

      bindMounts."${settings.home}/.ssh/authorized_keys" = {
        hostPath = "/persist${settings.home}/.ssh/authorized_keys";
        isReadOnly = true;
      };

      config =
        { config, lib, ... }:
        {
          nixpkgs.overlays = [
            (final: prev: {
              local = import ../../../pkgs { pkgs = prev; };
            })
          ];
          imports = [
            inputs.agenix.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            core.age
            core.home-manager
            core.machine
            core.programs
            core.resolved
            core.security
            core.services
            core.stylix
            core.system
            core.users
            core.virtualisation
            server.age
          ];

          age.identityPaths = [ "${settings.home}/.ssh/age" ];

          machine.type = "container";

          services.openssh.ports = [ 2222 ];
          networking.firewall.allowedTCPPorts = [ settings.nvimServerPort ];

          home-manager.users.${settings.user}.imports =
            (with homeManager.user; [
              base
            ])
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
              jq
              k8s
              lazydocker
              lazygit
              neovim-minimal
              nix-index
              packages
              pi
              ripgrep
              starship
              tealdeer
              yazi
              zoxide
              zsh
            ]);

          home-manager.extraSpecialArgs = {
            inherit inputs;
            nvimServerPort = settings.nvimServerPort;
            dotfilesDir = "${settings.home}/dotfiles";
          };

          systemd.tmpfiles.rules = with config.age; [
            "L+ /home/${settings.user}/.config/gh/hosts.yml - - - - ${secrets."gh-hosts.yaml".path}"
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
            defaultGateway = lan.containerHostAddress;
          };

          system.stateVersion = settings.stateVersion;
        };
    };
  };
}
