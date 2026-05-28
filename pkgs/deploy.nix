{
  writeShellApplication,
  git,
  nix,
  nh,
  nixos-rebuild,
  dotfiles,
}:
writeShellApplication {
  name = "deploy";
  runtimeInputs = [
    git
    nix
    nh
    nixos-rebuild
  ];
  text = ''
    git -C ${dotfiles} pull --quiet
    nh os switch ${dotfiles}
  '';
}
