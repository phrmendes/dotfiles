{
  lib,
  stdenv,
  makeWrapper,
  systemd,
  cryptsetup,
  tpm2-tss,
  btrfs-progs,
  dialog,
  coreutils,
  findutils,
  gnugrep,
  util-linux,
}:
let
  runtimePath = lib.makeBinPath [
    systemd
    cryptsetup
    btrfs-progs
    dialog
    coreutils
    findutils
    gnugrep
    util-linux
  ];

  wrappers = {
    btrfs-choose-snapshot = "choose-snapshot.sh";
    btrfs-delete-old-snapshots = "delete-old-snapshots.sh";
    encryption = "encryption.sh";
  };
in
stdenv.mkDerivation {
  pname = "scripts";
  version = "0.1.0";

  src = ../files/scripts;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ tpm2-tss ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin

    install -m644 lib.sh $out/libexec/lib.sh
    install -m755 choose-snapshot.sh $out/libexec/choose-snapshot.sh
    install -m755 delete-old-snapshots.sh $out/libexec/delete-old-snapshots.sh
    install -m755 encryption.sh $out/libexec/encryption.sh

    patchShebangs $out/libexec

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: script: ''
        makeWrapper $out/libexec/${script} $out/bin/${name} \
          --prefix PATH : $out/libexec \
          --prefix PATH : ${runtimePath}
      '') wrappers
    )}

    runHook postInstall
  '';

  meta = {
    description = "Initrd and boot scripts for the NixOS root";
    mainProgram = "encryption";
  };
}
