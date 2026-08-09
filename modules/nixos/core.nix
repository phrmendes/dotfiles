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
      isWorkstation = builtins.elem (config.workstation.type or "server") [
        "desktop"
        "laptop"
      ];
    in
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.impermanence.nixosModules.impermanence
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      nix.settings.experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];

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
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
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
          ];
          luks.devices."crypted".device = "/dev/disk/by-partlabel/disk-main-luks";
          systemd = {
            enable = true;
            services = {
              systemd-udevd.after = [ "systemd-modules-load.service" ]; # Workaround for https://github.com/NixOS/nixpkgs/issues/428775
              initrd-btrfs-cleanup = {
                description = "Btrfs subvolume cleanup and recreation";
                requiredBy = [ "sysroot.mount" ];
                before = [ "sysroot.mount" ];
                unitConfig = {
                  After = [ "systemd-cryptsetup@crypted.service" ];
                  Requires = [ "systemd-cryptsetup@crypted.service" ];
                  DefaultDependencies = false;
                };
                serviceConfig = {
                  Type = "oneshot";
                  RemainAfterExit = true;
                };
                script = builtins.readFile ../../files/btrfs.sh;
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
            nodejs_latest
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
        zsh.enable = true;

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
        dbus.packages = with pkgs; [ gcr ];
        udev.enable = true;
        envfs.enable = false;
        fstrim.enable = true;
        geoclue2.enable = isWorkstation;
        gvfs.enable = isWorkstation;
        journald.extraConfig = "SystemMaxUse=1G";
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
            shell = pkgs.zsh;
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

      virtualisation.containers.enable = true;
      console.keyMap = "us";
      system.stateVersion = settings.stateVersion;
    };
}
