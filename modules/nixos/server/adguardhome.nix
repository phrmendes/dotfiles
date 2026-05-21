{ config, ... }:
let
  inherit (config.settings) lan;
  inherit (config) dotfilesLib;
in
{
  modules.nixos.server.adguardhome =
    { config, ... }:
    let
      port = 3000;
      dnsPort = 53;
    in
    {
      networking.firewall = dotfilesLib.mkFirewallPort dnsPort;

      server.homepage.services.adguardhome = {
        dataDir = "/var/lib/AdGuardHome";
        url = "adguardhome.${config.server.caddy.domain}";
        monitoredServices = [ "adguardhome" ];
        homepage = {
          name = "AdGuard Home";
          description = "DNS ad blocking";
          icon = "sh-adguard-home";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "adguardhome" port;

      services.adguardhome = {
        enable = true;
        host = "127.0.0.1";
        inherit port;
        mutableSettings = true;
        settings = {
          safebrowsing_enabled = true;
          blocked_services.ids = [
            "betano"
            "betfair"
            "betway"
            "bigo_live"
            "blaze"
          ];
          user_rules = [
            "@@||framed.wtf^"
            "@@||digitalcore.club^"
            "@@||bunkrr.su^"
            "@@||herman.bearblog.dev^"
            "@@||workers.new^"
            "@@||vardis.space^"
            "@@||freedium.cfd^"
            "@@||umami.is^"
            "@@||prod-global-mobile-analytics-global.nubank.com.br^"
          ];
          filtering.filters = [
            {
              id = 1;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
              name = "AdGuard DNS filter";
            }
            {
              id = 1750735958;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
              name = "AdGuard DNS Popup Hosts filter";
            }
            {
              id = 1750735964;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt";
              name = "HaGeZi's Gambling - Ads & Tracking";
            }
            {
              id = 1750735965;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_56.txt";
              name = "HaGeZi's Samsung Tracker";
            }
            {
              id = 1750735966;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_57.txt";
              name = "HaGeZi's Windows/Office Tracker";
            }
            {
              id = 1750735970;
              enabled = true;
              url = "https://phishing.army/download/phishing_filter_url.txt";
              name = "Phishing URL Blocklist (PhishTank and OpenPhish)";
            }
            {
              id = 1750735976;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt";
              name = "Phishing Army";
            }
            {
              id = 1760929410;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
              name = "Steven Black's List";
            }
            {
              id = 1766457249;
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_49.txt";
              name = "HaGeZi's Ultimate Blocklist";
            }
          ];
          dns = {
            bind_hosts = [
              "127.0.0.1"
              lan.serverAddress
            ];
            port = dnsPort;
            upstream_mode = "load_balance";
            cache_enabled = true;
            refuse_any = true;
            upstream_dns = [
              "https://dns.adguard-dns.com/dns-query"
              "https://dns.cloudflare.com/dns-query"
            ];
            bootstrap_dns = [
              "9.9.9.10"
              "149.112.112.10"
              "2620:fe::10"
              "2620:fe::fe:10"
            ];
            rewrites = [
              {
                domain = "server.local";
                answer = lan.serverAddress;
              }
              {
                domain = "desktop.local";
                answer = lan.desktopAddress;
              }
              {
                domain = "kvm.local";
                answer = lan.kvmAddress;
              }
            ];
          };
        };
      };
    };
}
