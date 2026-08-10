{ config, inputs, ... }:
let
  inherit (config) settings;
  commonDirs = [
    ".ansible"
    ".cache/helm"
    ".cache/helmfile"
    ".cache/keepassxc"
    ".cache/noctalia"
    ".config"
    ".docker"
    ".kube"
    ".local/share/Steam"
    ".local/share/atuin"
    ".local/share/direnv"
    ".local/share/helm"
    ".local/share/k9s"
    ".local/share/keyrings"
    ".local/share/mods"
    ".local/share/neovide"
    ".local/share/nix"
    ".local/share/nvim"
    ".local/share/uv"
    ".local/share/zathura"
    ".local/share/zoxide"
    ".local/share/zsh"
    ".local/state/comma"
    ".local/state/home-manager"
    ".local/state/keepassxc"
    ".local/state/nix"
    ".local/state/noctalia"
    ".local/state/nvim"
    ".local/state/wireplumber"
    ".mozilla"
    ".password-store"
    ".pi/agent/sessions"
    ".ssh"
    ".steam"
    ".zotero"
    "Documents"
    "Downloads"
    "Pictures"
    "Projects"
    "Videos"
    "Zotero"
  ];
  versioning = {
    simple = {
      type = "simple";
      params = {
        keep = "10";
        cleanoutDays = "30";
      };
    };
    trashcan = {
      type = "trashcan";
      params.cleanoutDays = "15";
    };
  };
  workstations = [
    "desktop"
    "laptop"
    "server"
  ];
  allDevices = workstations ++ [
    "phone"
    "tablet"
  ];
  trashcanFolder = path: devices: {
    inherit path devices;
    versioning = versioning.trashcan;
  };
in
{
  nixosModules.workstation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.dotfilesLib) mkSecretReadable;
    in
    {
      age.secrets."pi.json" = mkSecretReadable {
        owner = settings.user;
        file = ../../secrets/pi.age.json;
        path = "${settings.home}/.pi/agent/auth.json";
      };

      services = {
        flatpak.enable = true;

        greetd = {
          enable = true;
          settings = rec {
            initial_session = {
              user = settings.user;
              command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
            };
            default_session = initial_session;
          };
        };

        power-profiles-daemon.enable = lib.mkDefault true;
        upower.enable = true;

        pipewire = {
          enable = true;
          pulse.enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
        };

        syncthing = {
          user = settings.user;
          enable = true;
          configDir = "${settings.home}/.config/syncthing";
          openDefaultPorts = true;
          overrideDevices = true;
          overrideFolders = true;
          settings = {
            options = {
              localAnnounceEnabled = true;
              urAccepted = 1;
            };
            devices = {
              "phone".id = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
              "tablet".id = "N6ESTXQ-B2CWCVM-SHBRV7Y-KOP5JE5-P7CQJ2Q-LQIILS3-NWMBIBU-TTJ74QG";
              "server".id = "WO4EEDG-FAZ3VXA-VCV6ZCD-U5TFYFN-QRVFWVO-UXBR4DQ-KDOST52-HD5WNAZ";
              "desktop".id = "GX2DVTR-JHGAK4J-FSWUSWO-T6LXWWV-M7KWB6C-RQHO3YA-XCRMS3P-76YHUAG";
              "laptop".id = "IAG66TX-VIHT5YS-4T7AZBC-IK2OR6D-BHLITJL-H5O27NZ-VGKUTSD-WJ7YIQE";
            };
            folders = {
              "documents" = trashcanFolder "${settings.home}/Documents/documents" workstations;
              "images" = trashcanFolder "${settings.home}/Pictures/images" workstations;
              "notes" = {
                path = "${settings.home}/Documents/notes";
                versioning = versioning.simple;
                devices = allDevices;
              };
              "ufabc" = trashcanFolder "${settings.home}/Documents/ufabc" (workstations ++ [ "tablet" ]);
              "collections" = trashcanFolder "${settings.home}/Documents/collections" workstations;
              "excalidraw" = trashcanFolder "${settings.home}/Documents/excalidraw" workstations;
              "reading" = trashcanFolder "${settings.home}/Documents/reading" allDevices;
              "keepassxc" = trashcanFolder "${settings.home}/Documents/keepassxc" allDevices;
            };
          };
        };
      };

      programs = {
        dconf.enable = true;
        hyprland = {
          enable = true;
          withUWSM = true;
        };
        virt-manager.enable = true;
      };

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
          };
        };
        podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      environment = {
        persistence."/persist".users.${settings.user}.directories = commonDirs ++ [
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".keychain";
            mode = "u=rwx,go=";
          }
        ];
        systemPackages = [
          inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        config.hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };
    };
}
