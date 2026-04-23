{ inputs, ... }:
{
  modules.nixos.core = {
    nix-settings = {
      nix = {
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
        ];
        settings = {
          download-buffer-size = 1048576000;
          auto-optimise-store = true;
          accept-flake-config = true;
          trusted-users = [
            "root"
            "@wheel"
          ];
          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      };
    };

    nixpkgs = {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        (final: prev: {
          python3 = prev.python3.override {
            packageOverrides = pyFinal: pyPrev: {
              vertexai-stub = pyPrev.buildPythonPackage {
                pname = "vertexai-stub";
                version = "0.0.1";
                format = "pyproject";
                src = final.writeTextFile {
                  name = "vertexai-stub-src";
                  text = ''
                    [build-system]
                    requires = ["setuptools"]
                    build-backend = "setuptools.backends.legacy:build"
                    [project]
                    name = "vertexai-stub"
                    version = "0.0.1"
                  '';
                  destination = "/pyproject.toml";
                };
                postInstall = ''
                  mkdir -p $out/lib/python3.13/site-packages/vertexai/preview
                  touch $out/lib/python3.13/site-packages/vertexai/__init__.py
                  touch $out/lib/python3.13/site-packages/vertexai/preview/__init__.py
                  touch $out/lib/python3.13/site-packages/vertexai/preview/language_models.py
                '';
              };
              litellm = pyPrev.litellm.overridePythonAttrs (old: {
                dependencies = (old.dependencies or [ ]) ++ [ pyFinal.vertexai-stub ];
              });
            };
          };
          python3Packages = final.python3.pkgs;
        })
      ];
    };
  };
}
