{ inputs, ... }:
{
  modules.homeManager.dev.packages =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          curl
          elixir
          hurl
          jdk
          jqp
          just
          lima
          nix-prefetch-github
          nodejs_latest
          parallel
          prek
          python314
          sqlite
          uv
          (google-cloud-sdk.withExtraComponents (
            with google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]
          ))
        ]
        ++ builtins.attrValues pkgs.local;
    };
}
