{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.modules) homeManager;
in
{
  modules.nixos.server.container = _: {
    boot.enableContainers = true;
    virtualisation.containers.enable = true;
    networking.firewall.allowedTCPPorts = [ 2222 ];

    containers.dev = {
      autoStart = true;
      bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;

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
          ];

          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

          age.secrets = {
            "claude-service-account.json" = {
              file = ../secrets/claude-service-account.json.age;
              owner = settings.user;
              group = "users";
              mode = "0440";
            };
            "litellm.env" = {
              file = ../secrets/litellm.env.age;
              owner = settings.user;
              group = "users";
              mode = "0440";
            };
            "docker-config.json" = {
              file = ../secrets/docker-config.json.age;
              owner = settings.user;
              group = "users";
              mode = "0400";
            };
            "github-pat" = {
              file = ../secrets/github-pat.age;
              owner = settings.user;
              group = "users";
              mode = "0400";
            };
          };

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

          services.litellm = {
            enable = true;
            host = "127.0.0.1";
            port = 14141;
            environmentFile = config.age.secrets."litellm.env".path;
            settings = {
              model_list = [
                {
                  model_name = "claude-sonnet-4-5@20250929";
                  litellm_params.model = "vertex_ai/claude-sonnet-4-5@20250929";
                }
              ];
              litellm_settings.drop_params = true;
            };
          };

          virtualisation.docker.rootless = {
            enable = true;
            setSocketVariable = true;
          };

          programs.zsh.enable = true;

          users.users.${settings.user} = {
            isNormalUser = true;
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
          ];

          home-manager.sharedModules = [
            {
              programs.gh.settings = {
                git_protocol = "https";
                prompt = "enabled";
              };
              home.sessionVariablesExtra = ''
                export GITHUB_TOKEN="$(cat ${config.age.secrets."github-pat".path})"
              '';
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
