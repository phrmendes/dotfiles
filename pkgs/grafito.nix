{ stdenv, src }:
stdenv.mkDerivation {
  pname = "grafito";
  version = "0.17.0";
  inherit src;
  dontUnpack = true;
  installPhase = ''
    install -Dm755 $src $out/bin/grafito
  '';
}
