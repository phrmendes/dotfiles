{ stdenv, fetchFromGitHub }:

{
  sddm-nordic = stdenv.mkDerivation rec {
    pname = "sddm-nordic";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
        mkdir -p $out/share/sddm/themes
        cp -aR $src $out/share/sddm/themes/nordic
    '';
    src = fetchFromGitHub {
      owner = "phrmendes";
      repo = "nordic_sddm_theme";
      rev = "v${version}";
      sha256 = "19axwzykzbhx2p6c4z7jk6qps6hp0a5z64ma93yhzda9hcw4c84x";
    };
  };
}
