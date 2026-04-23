{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.modules) homeManager;
  inherit (config.modules.nixos) server;
in
{
  modules.nixos.server.container =
    { ... }:
    {
      boot.enableContainers = true;
      virtualisation.containers.enable = true;
      networking.firewall.allowedTCPPorts = [ 2222 ];

      containers.dev = {
        autoStart = true;
        bindMounts."${settings.home}/.ssh/age" = {
          hostPath = "/persist${settings.home}/.ssh/age";
          isReadOnly = true;
        };
        bindMounts."/mnt/external/pi" = {
          hostPath = "/mnt/external/pi";
          isReadOnly = false;
        };

        config =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              inputs.agenix.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
              server.litellm
              server.age
            ];

            age.identityPaths = [ "${settings.home}/.ssh/age" ];

            services.openssh = {
              enable = true;
              ports = [ 2222 ];
              settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "no";
              };
              extraConfig = ''
                Match User ${settings.user}
                  ForceCommand ${pkgs.tmux}/bin/tmux new-session -A -s default
              '';
            };

            virtualisation.docker.rootless = {
              enable = true;
              setSocketVariable = true;
            };

            security.sudo.wheelNeedsPassword = false;

            programs.zsh.enable = true;

            users.users.${settings.user} = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              group = "users";
              shell = pkgs.zsh;
              openssh.authorizedKeys.keys = [
                (builtins.readFile ../files/ssh-keys/main.txt)
                (builtins.readFile ../files/ssh-keys/phone.txt)
                (builtins.readFile ../files/ssh-keys/laptop.txt)
              ];
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
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

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved = {
              enable = true;
              settings.Resolve.DNSStubListener = "no";
            };
            systemd.sockets.systemd-resolved.enable = false;

            system.stateVersion = "25.05";
          };
      };
    };
}
