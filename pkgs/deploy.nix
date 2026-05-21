{
  writeShellApplication,
  git,
  nh,
  nixos-rebuild,
  dotfiles,
}:
writeShellApplication {
  name = "deploy";
  runtimeInputs = [
    git
    nh
    nixos-rebuild
  ];
  text = ''
    git -C ${dotfiles} pull --quiet
    nh os switch ${dotfiles}
  '';
}
