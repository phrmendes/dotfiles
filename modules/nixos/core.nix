{
  config,
  inputs,
  ...
}:
let
  inherit (config) settings;
in
{
  nixosModules.core =
    {
      config,
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    let
      utils = import ../../utils { inherit lib; };
      btrfsTop = "/run/btrfs";
      isWorkstation = builtins.elem (config.workstation.type or "server") [
        "desktop"
        "laptop"
      ];
    in
    {
      options.utils = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        readOnly = true;
        default = utils;
      };

      imports = [
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.impermanence.nixosModules.impermanence
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      config = {
        nix.settings = {
          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
          extra-substituters = [
            "https://pi.cachix.org"
            "https://nix-community.cachix.org"
          ];
          extra-trusted-public-keys = [
            "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };

        specialisation.pick-root.configuration.boot.kernelParams = [ "nixos.root_snapshot=ask" ];

        age.identityPaths = [ "/persist${settings.home}/.ssh/age" ];

        boot = {
          kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
          tmp.cleanOnBoot = true;
          kernelPackages = pkgs.linuxPackages;
          supportedFilesystems = [
            "btrfs"
            "ntfs"
          ];
          loader = {
            timeout = 5;
            efi = {
              canTouchEfiVariables = true;
              efiSysMountPoint = "/boot";
            };
            limine = {
              enable = true;
              maxGenerations = 3;
            };
          };
          kernelModules = [ "fuse" ];
          initrd = {
            kernelModules = [ "tun" ];
            availableKernelModules = [
              "xhci_pci"
              "ahci"
              "usb_storage"
              "usbhid"
              "sd_mod"
              "nvme"
              "tpm_tis"
              "tpm_crb"
            ];
            luks.devices."crypted" = {
              device = "/dev/disk/by-partlabel/disk-main-luks";
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            };
            systemd = {
              enable = true;
              initrdBin = [ pkgs.dialog ];
              contents = {
                "/etc/dialogrc".source = ../../files/dialogrc;
              };
              services = {
                systemd-udevd.after = [ "systemd-modules-load.service" ]; # Workaround for https://github.com/NixOS/nixpkgs/issues/428775
                rotate-root = {
                  description = "Rotate the btrfs root and keep the newest old roots";
                  requiredBy = [ "sysroot.mount" ];
                  before = [ "sysroot.mount" ];
                  after = [ "systemd-cryptsetup@crypted.service" ];
                  requires = [ "systemd-cryptsetup@crypted.service" ];
                  unitConfig.DefaultDependencies = false;
                  serviceConfig.Type = "oneshot";
                  script = ''
                    mkdir -p /top
                    mount -o subvolid=5 /dev/mapper/crypted /top
                    mkdir -p /top/old_roots

                    pick=
                    read -r cmdline </proc/cmdline
                    case " $cmdline " in
                      *" nixos.root_snapshot=ask "*)
                        set --
                        for d in $(ls -d /top/old_roots/* 2>/dev/null | sort -r); do
                          set -- "$@" "''${d##*/}" ""
                        done
                        if [ $# -gt 0 ]; then
                          pick=$(TERM=linux dialog --timeout 60 --menu "Boot which root?" 20 76 12 "$@" 2>&1 1>/dev/console </dev/console) || pick=
                        fi
                        ;;
                    esac
                    case $pick in */* | .*) pick= ;; esac

                    if [ -e /top/root ]; then
                      read -r uuid </proc/sys/kernel/random/uuid
                      mv /top/root "/top/old_roots/$(date +%F_%T)_''${uuid%%-*}"
                    fi

                    if [ -n "$pick" ] && [ -d "/top/old_roots/$pick" ]; then
                      mv "/top/old_roots/$pick" /top/root
                    else
                      btrfs subvolume create /top/root
                    fi

                    ls -d /top/old_roots/* 2>/dev/null | sort -r | tail -n +$((${toString settings.keepOldRoots} + 1)) | while read -r old; do
                      btrfs subvolume delete --recursive "$old"
                    done
                    umount /top
                  '';
                };
              };
            };
          };
        };

        fileSystems = {
          "/persist".neededForBoot = lib.mkForce true;
          "/boot" = {
            device = "/dev/disk/by-partlabel/disk-main-ESP";
            fsType = "vfat";
            options = [
              "umask=0077"
            ];
          };
          ${btrfsTop} = {
            device = "/dev/mapper/crypted";
            fsType = "btrfs";
            options = [
              "subvolid=5"
              "noatime"
              "compress=zstd"
              "nofail"
            ];
          };
        };

        hardware = {
          keyboard.qmk = lib.mkIf isWorkstation { enable = true; };
          enableAllFirmware = true;
          uinput.enable = true;
          bluetooth = lib.mkIf isWorkstation {
            enable = true;
            powerOnBoot = true;
            settings.Policy.AutoEnable = true;
            input.General = {
              ClassicBondedOnly = false;
              LEBondedOnly = false;
              UserspaceHID = true;
            };
          };
        };

        networking.networkmanager.enable = true;

        systemd.services = {
          prefer-lan-routes = {
            description = "Prefer direct LAN routes over Tailscale";
            after = [
              "network-online.target"
              "tailscaled.service"
            ];
            wants = [
              "network-online.target"
              "tailscaled.service"
            ];
            wantedBy = [ "multi-user.target" ];
            path = [ pkgs.iproute2 ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = "ip rule add priority 5200 to ${settings.lan.subnet} table main";
            postStop = "ip rule del priority 5200 to ${settings.lan.subnet} table main";
          };

        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          sharedModules = [ inputs.nix-index-database.homeModules.default ];
        };

        environment = {
          persistence."/persist" = {
            hideMounts = true;
            directories = [
              "/etc"
              "/var/db"
              "/var/lib"
              "/var/log"
            ];
          };
          systemPackages =
            with pkgs;
            [
              inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
              cachix
              coreutils-full
              curl
              dig
              docker-credential-helpers
              egl-wayland
              file
              findutils
              gcc
              gnumake
              gnused
              gzip
              lsof
              mlocate
              openssl
              p7zip
              psmisc
              python314
              rar
              sqlite
              unar
              unzip
              wget
              xdg-utils
              zip
            ]
            ++ (with pkgs.unixtools; [
              net-tools
              netstat
            ])
            ++ lib.optionals isWorkstation [
              libsecret
            ];
        };

        programs = {
          nano.enable = false;
          fuse.userAllowOther = true;
          command-not-found.enable = false;
          nushell.enable = true;

          nix-ld = {
            enable = true;
            libraries = with pkgs; [
              glib
              libGL
              libxxf86vm
            ];
          };

          ssh = lib.mkIf isWorkstation {
            startAgent = true;
            askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
          };

          nh = {
            enable = true;
            clean = {
              enable = true;
              extraArgs = "--keep-since 3d --keep 5";
            };
          };
        };

        security = {
          rtkit.enable = true;
          polkit.enable = true;
          sudo = {
            enable = true;
            wheelNeedsPassword = false;
          };
        };

        services = {
          dbus.packages = with pkgs; [ gcr_4 ];
          udev.enable = true;
          envfs.enable = false;
          fstrim.enable = true;
          geoclue2.enable = isWorkstation;
          gvfs.enable = isWorkstation;
          ntpd-rs.enable = true;

          gnome = {
            gcr-ssh-agent.enable = false;
            gnome-keyring.enable = false;
          };

          btrfs.autoScrub = {
            enable = true;
            interval = "monthly";
          };

          openssh = {
            allowSFTP = true;
            enable = true;
            settings = {
              KbdInteractiveAuthentication = false;
              PasswordAuthentication = false;
              PermitRootLogin = "no";
              PubKeyAuthentication = true;
            };
          };

          resolved = {
            enable = true;
            settings.Resolve = {
              DNSSEC = "false";
              LLMNR = "false";
            };
          };

          tailscale = {
            enable = true;
            useRoutingFeatures = lib.mkDefault "client";
          };
        };

        stylix =
          let
            firaFont = {
              package = pkgs.fira;
              name = "Fira Sans";
            };
          in
          {
            enable = true;
            enableReleaseChecks = false;
            image = ../../files/background.png;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
            polarity = "dark";
            targets.kmscon.enable = false;
            cursor = {
              name = "Adwaita";
              package = pkgs.adwaita-icon-theme;
              size = 24;
            };
            fonts = {
              sizes = {
                applications = 12;
                terminal = 13;
              };
              serif = firaFont;
              sansSerif = firaFont;
              monospace = {
                package = pkgs.nerd-fonts.meslo-lg;
                name = "MesloLGMDZ Nerd Font";
              };
              emoji = {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
              };
            };
          };

        swapDevices = [
          {
            device = "/persist/swapfile";
            size = 8192;
          }
        ];

        users = {
          mutableUsers = true;
          groups.external = { };
          users = {
            ${settings.user} = {
              inherit (settings) home;
              shell = pkgs.nushell;
              password = "changeme";
              openssh.authorizedKeys.keys = [
                (builtins.readFile ../../files/ssh/main.txt)
                (builtins.readFile ../../files/ssh/phone.txt)
                (builtins.readFile ../../files/ssh/laptop.txt)
                (builtins.readFile ../../files/ssh/server.txt)
              ];
              isNormalUser = true;
              uid = 1000;
              linger = true;
              extraGroups = [
                "external"
                "keys"
                "networkmanager"
                "wheel"
              ]
              ++ lib.optionals isWorkstation [
                "adbusers"
                "audio"
                "libvirtd"
                "video"
              ];
            };
          };
        };

        time = {
          timeZone = "America/Sao_Paulo";
          hardwareClockInLocalTime = false;
        };
        virtualisation.containers.enable = true;
        console.keyMap = "us";
        system.stateVersion = settings.stateVersion;
      };
    };
}
