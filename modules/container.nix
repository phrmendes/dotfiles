{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.modules) homeManager;
  inherit (config.modules.nixos) server core;
  lan = settings.lan;
  baseDevModules = with homeManager.dev; [
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
    nix-index
    packages
    ripgrep
    starship
    tealdeer
    tmux
    yazi
    zoxide
    zsh
  ];
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
      externalInterface = lan.interface;
      forwardPorts = [
        {
          sourcePort = 2222;
          destination = "${lan.containerLocalAddress}:2222";
          proto = "tcp";
        }
      ];
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
          nixpkgs.overlays = [
            (final: prev: {
              local = import ../pkgs { pkgs = prev; };
            })
          ];
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
            ++ baseDevModules
            ++ (with homeManager.dev; [
              helix
              pi
            ]);

          systemd.tmpfiles.rules = with config.age; [
            "L+ /home/${settings.user}/.docker/config.json - - - - ${secrets."docker-config.json".path}"
            "L+ /home/${settings.user}/.config/gh/hosts.yml - - - - ${secrets."gh-hosts.yaml".path}"
            "L+ /home/${settings.user}/Projects - - - - /mnt/external/pi"
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

          services.resolved = {
            enable = true;
            settings.Resolve = {
              DNSSEC = "false";
              LLMNR = "false";
            };
          };

          system.stateVersion = "26.05";
        };
    };
  };
}
