let
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
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.src_valid_mark" = 1;
      };

      networking.firewall.allowedUDPPorts = [ 51820 ];

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
          NODE_EXTRA_CA_CERTS = "/etc/ca.crt";
          OAUTH_PROVIDERS = "oidc";
          OAUTH_OIDC_SERVER = "https://auth.${config.caddy.domain}";
          OAUTH_OIDC_NAME = "Authelia";
          HOST = "127.0.0.1";
          PORT = toString port;
          INSECURE = "true";
          TRUSTED_PROXIES = "127.0.0.1";
          DISABLE_IPV6 = "true";
          DISABLE_VERSION_CHECK = "true";
        };
        volumes = [
          "/var/lib/wg-easy:/etc/wireguard"
          "${../../files/ca.crt}:/etc/ca.crt:ro"
        ];
        extraOptions = [
          "--network=host"
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
        ];
      };
    };
}
