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
  efibootmgr,
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
    efibootmgr
    findutils
    gnugrep
    util-linux
  ];

  wrappers = {
    btrfs-select-root = "select-root.sh";
    btrfs-delete-old-snapshots = "delete-old-snapshots.sh";
    encryption = "encryption.sh";
    limine = "limine.sh";
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
    install -m755 select-root.sh $out/libexec/select-root.sh
    install -m755 delete-old-snapshots.sh $out/libexec/delete-old-snapshots.sh
    install -m755 encryption.sh $out/libexec/encryption.sh
    install -m755 limine.sh $out/libexec/limine.sh

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
