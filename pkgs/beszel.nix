{
  beszel,
  buildNpmPackage,
  src,
}:

let
  version = "0.21.0";
in
beszel.overrideAttrs (old: {
  inherit version src;
  webui = buildNpmPackage {
    pname = "beszel";
    inherit version src;
    npmFlags = [ "--legacy-peer-deps" ];
    buildPhase = ''
      runHook preBuild
      npx lingui extract --overwrite
      npx lingui compile
      node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out
      runHook postInstall
    '';
    sourceRoot = "source/internal/site";
    npmDepsHash = "sha256-mYAD8FrQwa+F/VgGxFpe8vqucfZaM0PmY+gJJqw1IKk=";
  };
  tags = builtins.filter (t: t != "testing") (old.tags or [ ]);
  vendorHash = "sha256-xQToxS84d3xF+3ebpj6+010dqrRaNkRkGLh+tJpyttA=";
  doCheck = false;
})
