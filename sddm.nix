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
      sha256 = "1nqby92gkxlzg6vdjyz65019cz3k1qjc2f041a2pkf830gf2dvjk";
    };
  };
}
