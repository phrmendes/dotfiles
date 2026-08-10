{ caddy }:

caddy.withPlugins {
  plugins = [ "github.com/caddy-dns/desec@v1.1.0" ];
  hash = "sha256-sy924nxkritb+DzfyI2VJowYK8JyCHQyfXCmtiFDI2w=";
}
