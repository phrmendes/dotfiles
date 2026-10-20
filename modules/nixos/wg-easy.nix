{ config, ... }:
let
  inherit (config) settings;
  port = 51821;
in
{
  nixosModules.wg-easy =
    { config, ... }:
    {
      boot.kernelModules = [
        "wireguard"
        "nft_masq"
      ];

      boot.kernel.sysctl = {
        "net.ipv4.conf.all.src_valid_mark" = 1;
      };

      networking = {
        firewall = {
          allowedUDPPorts = [ 51820 ];
          extraCommands = ''
            iptables -N wg-forward 2>/dev/null || true
            iptables -F wg-forward
            iptables -A wg-forward -d ${settings.lan.routerAddress} -p tcp -m multiport --dports 22,80,443 -j ACCEPT
            iptables -A wg-forward -j DROP
            iptables -D FORWARD -i wg0 -j wg-forward 2>/dev/null || true
            iptables -I FORWARD 1 -i wg0 -j wg-forward
          '';
          extraStopCommands = ''
            iptables -D FORWARD -i wg0 -j wg-forward 2>/dev/null || true
            iptables -F wg-forward 2>/dev/null || true
            iptables -X wg-forward 2>/dev/null || true
          '';
        };
        nat = {
          enable = true;
          externalInterface = settings.lan.interface;
          internalInterfaces = [ "wg0" ];
        };
      };

      systemd.tmpfiles.rules = [ "d /var/lib/wg-easy 0700 root root -" ];

      homepage.services.wg-easy = {
        url = "wg.${config.caddy.domain}";
        homepage = {
          name = "WireGuard";
          description = "VPN";
          icon = "sh-wireguard";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "wg";
        inherit port;
        auth = true;
      };

      virtualisation.oci-containers.containers.wg-easy = {
        image = "ghcr.io/wg-easy/wg-easy:15";
        environmentFiles = [ config.age.secrets."wg-easy.env".path ];
        environment = {
          DISABLE_IPV6 = "true";
          DISABLE_VERSION_CHECK = "true";
          HOST = "127.0.0.1";
          NODE_EXTRA_CA_CERTS = "/etc/ca.crt";
          OAUTH_AUTO_REGISTER = "true";
          OAUTH_OIDC_CLIENT_ID = "wg-easy";
          OAUTH_OIDC_NAME = "Authelia";
          OAUTH_OIDC_SERVER = "https://auth.${config.caddy.domain}";
          OAUTH_PROVIDERS = "oidc";
          PORT = toString port;
          TRUSTED_PROXIES = "127.0.0.1";
        };
        volumes = [
          "/var/lib/wg-easy:/etc/wireguard"
          "${../../files/ca.crt}:/etc/ca.crt:ro"
        ];
        extraOptions = [
          "--network=host"
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--health-cmd=wget -q --spider http://127.0.0.1:${toString port}/"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
          "--health-start-period=15s"
        ];
      };
    };
}
