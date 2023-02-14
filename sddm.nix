{ stdenv, fetchFromGitHub }:

{
  nordic-custom-theme = stdenv.mkDerivation rec {
    pname = "sddm-nordic-custom-theme";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
        mkdir -p $out/share/sddm/themes
        cp -aR $src $out/share/sddm/themes/nordic-custom-theme
    '';
    src = fetchFromGitHub {
      owner = "phrmendes";
      repo = "nordic_sddm_theme";
      rev = "v${version}";
      sha256 = "19axwzykzbhx2p6c4z7jk6qps6hp0a5z64ma93yhzda9hcw4c84x";
    };
  };
}
