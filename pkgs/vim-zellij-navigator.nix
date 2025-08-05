{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "vim-zellij-navigator";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/${version}/vim-zellij-navigator.wasm";
    sha256 = "sha256-d+Wi9i98GmmMryV0ST1ddVh+D9h3z7o0xIyvcxwkxY0=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/zellij/plugins
    cp $src $out/share/zellij/plugins/vim-zellij-navigator.wasm

    runHook postInstall
  '';

  meta = with lib; {
    description = "Seamless navigation between vim and zellij";
    homepage = "https://github.com/hiasr/vim-zellij-navigator";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
