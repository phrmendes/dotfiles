{ caddy }:

caddy.withPlugins {
  plugins = [ "github.com/caddy-dns/desec@v1.1.0" ];
  hash = "sha256-oEKfWN5U1LI25vNvr/QZE2C8PQyIgBAGH/1YhUDoGr0=";
}
