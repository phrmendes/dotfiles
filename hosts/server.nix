{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.server.module =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports =
        (with nixos.core; [
          age
          boot
          disko
          filesystems
          hardware
          home-manager
          i18n
          impermanence
          networking
          nix-settings
          nixpkgs
          options
          programs
          security
          services
          stylix
          swap
          system-packages
          users
          virtualisation
        ])
        ++ (with nixos.server; [
          filesystems
          persistence
          secrets
          tailscale
        ]);

      networking.hostName = "server";
      programs.nh.flake = "/home/${settings.user}/dotfiles";
      machine.type = "server";

      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      boot.kernelModules = [
        "ip_tables"
        "ip6_tables"
      ];

      environment.systemPackages = with pkgs; [
        gh
        just
        neovim
        python313
      ];

      systemd =
        let
          dotfiles = "${settings.home}/dotfiles";
          just = "${pkgs.just}/bin/just";
          env = config.age.secrets."docker-compose.env".path;
          compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
          basePath = "${pkgs.bash}/bin:${pkgs.just}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin";
        in
        {
          timers.git-pull = {
            description = "Timer for git pull dotfiles";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "*-*-* 06:00,18:00";
              Persistent = true;
              RandomizedDelaySec = "5m";
            };
          };

          services = {
            docker-compose = {
              description = "Docker Compose services";
              after = [
                "docker.service"
                "network-online.target"
              ];
              wants = [ "network-online.target" ];
              requires = [ "docker.service" ];
              bindsTo = [ "docker.service" ];
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${dotfiles}/compose";
                ExecStart = "${compose} up --detach --remove-orphans --pull missing";
                ExecStop = "${compose} down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "on-failure";
                RestartSec = "30s";
              };
            };

            # Pulls dotfiles and writes prev/next SHAs to state file, then triggers downstream services
            git-pull = {
              description = "Pull dotfiles from remote";
              after = [ "network-online.target" ];
              wants = [
                "network-online.target"
                "nixos-apply.service"
                "compose-reload.service"
              ];
              serviceConfig = {
                Type = "oneshot";
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} pull";
                TimeoutStartSec = 120;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}" ];
              };
            };

            # Rebuilds NixOS if any config files changed since last pull
            nixos-apply = {
              description = "Apply NixOS configuration if changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} nixos-apply";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}:${pkgs.nixos-rebuild}/bin:/run/wrappers/bin" ];
              };
            };

            # Reloads docker-compose if secrets or compose files changed; always runs after nixos-apply
            compose-reload = {
              description = "Reload docker-compose if changed";
              after = [
                "git-pull.service"
                "nixos-apply.service"
              ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} compose-reload";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}:${pkgs.docker-compose}/bin" ];
              };
            };
          };
        };
          };

          services = {
            docker-compose = {
              description = "Docker Compose services";
              after = [
                "docker.service"
                "network-online.target"
              ];
              wants = [ "network-online.target" ];
              requires = [ "docker.service" ];
              bindsTo = [ "docker.service" ];
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${dotfiles}/compose";
                ExecStart = "${compose} up --detach --remove-orphans --pull missing";
                ExecStop = "${compose} down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "on-failure";
                RestartSec = "30s";
              };
            };

            git-pull = {
              description = "Pull dotfiles from remote";
              after = [ "network-online.target" ];
              wants = [
                "network-online.target"
                "nixos-apply.service"
                "compose-reload.service"
              ];
              serviceConfig = {
                Type = "oneshot";
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                TimeoutStartSec = 120;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${gitPath}" ];
              };
              script = ''
                mkdir -p ${stateDir}
                prev=$(git rev-parse HEAD)
                git pull --ff-only --quiet
                next=$(git rev-parse HEAD)
                printf 'PREV=%s\nNEXT=%s\n' "$prev" "$next" > ${stateFile}
              '';
            };

            nixos-apply = {
              description = "Apply NixOS configuration if changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [
                  "PATH=${pkgs.bash}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin:${pkgs.nixos-rebuild}/bin:/run/wrappers/bin"
                ];
              };
              script = ''
                . ${stateFile}
                if [ "$PREV" = "$NEXT" ]; then
                  echo "No changes, skipping."
                  exit 0
                fi
                changed=$(git -C ${dotfiles} diff --name-only "$PREV" "$NEXT")
                if echo "$changed" | grep -qE '^(hosts|modules|files|secrets|flake\.nix|flake\.lock)'; then
                  echo "NixOS config changed — rebuilding..."
                  nixos-rebuild switch --flake "${dotfiles}#server"
                else
                  echo "No NixOS config changes."
                fi
              '';
            };

            # Reloads docker-compose if compose files changed since last pull; always runs after nixos-apply
            compose-reload = {
              description = "Reload docker-compose if changed";
              after = [
                "git-pull.service"
                "nixos-apply.service"
              ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${dotfiles}/compose";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [
                  "PATH=${pkgs.bash}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin:${pkgs.docker-compose}/bin"
                ];
              };
              script = ''
                . ${stateFile}
                if [ "$PREV" = "$NEXT" ]; then
                  echo "No changes, skipping."
                  exit 0
                fi
                changed=$(git -C ${dotfiles} diff --name-only "$PREV" "$NEXT")
                if echo "$changed" | grep -qE '^(secrets/|compose/(docker-compose\.yaml|services/))'; then
                  echo "Secrets or compose files changed — reloading..."
                  ${compose} pull
                  ${compose} up --detach --remove-orphans
                else
                  echo "No compose changes."
                fi
              '';
            };
          };
        };

      home-manager.users.${settings.user} = {
        imports =
          (with homeManager.user; [
            base
          ])
          ++ (with homeManager.dev; [
            bat
            btop
            fd
            fzf
            git
            jq
            ripgrep
            zoxide
            zsh
          ]);

        xdg.configFile."nvim/init.lua".source = ../files/neovim.lua;
      };
    };
}
