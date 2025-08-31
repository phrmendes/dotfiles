{
  pkgs,
  config,
  lib,
  parameters,
  ...
}:
{
  imports = [
    ../shared
    ./age.nix
    ./systemd.nix
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
  programs.nh.flake = "/home/${parameters.user}/dotfiles";

  networking = {
    hostName = "server";
    networkmanager.dns = "systemd-resolved";

    nftables = {
      enable = true;
      tables.filter = {
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority filter; policy drop;

            # allow local traffic always
            ip saddr { 127.0.0.1, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } accept

            # allow established/related connections
            ct state { established, related } accept

            # allow loopback
            iifname lo accept

            # global access for wireguard vpn only
            udp dport 52820 accept

            # local network + wireguard subnet access for all services
            tcp dport { 22, 53, 80, 443, 2022, 7359, 9000, 22000, 51413 } ip saddr { 127.0.0.1, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } accept
            udp dport { 21027, 22000, 51413, 7359 } ip saddr { 127.0.0.1, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } accept

            # allow icmp from local networks only
            ip protocol icmp ip saddr { 127.0.0.1, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } accept

            # log and drop all other traffic (external access attempts)
            counter log prefix "EXTERNAL-BLOCK: " drop
          }
        '';
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      dig
      gh
      just
      lazyjournal
      lsof
      neovim
      python313
      unixtools.netstat
    ];

    persistence."/persist".users.${parameters.user}.directories = [
      "dotfiles"
      ".config"
      ".ssh"
      ".local/share"
      ".local/state"
    ];

    etc."fail2ban/action.d/gotify.conf".source = ../../dotfiles/fail2ban/gotify.conf;
  };

  fileSystems = {
    "/mnt/external" = {
      device = "/dev/disk/by-label/external";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  };

  services = {
    xserver.displayManager.lightdm.enable = false;

    tailscale = {
      useRoutingFeatures = "both";
      extraUpFlags = [ "--advertise-tags=tags:main" ];
      extraSetFlags = [ "--advertise-exit-node" ];
    };

    fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "1h";
      jails = {
        sshd = {
          enabled = true;
          settings = {
            action = ''
              %(banaction)s[name=%(__name__)s, bantime="%(bantime)s", port="%(port)s", protocol="%(protocol)s", chain="%(chain)s"]
              gotify[name=%(__name__)s]
            '';
            maxretry = 3;
            findtime = "10m";
            bantime = "1h";
          };
        };
        wireguard = {
          enabled = true;
          settings = {
            filter = "wireguard";
            logpath = "/var/log/messages";
            action = ''
              iptables-allports[name=wireguard, protocol=udp]
              gotify[name=wireguard]
            '';
            maxretry = 2;
            findtime = "5m";
            bantime = "24h";
            port = "52820";
          };
        };
      };
    };
  };

  home-manager.users.${parameters.user} = {
    bat.enable = true;
    btop.enable = true;
    fd.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;

    xdg.configFile."nvim/init.lua".source = ../../dotfiles/neovim.lua;
  };
}
