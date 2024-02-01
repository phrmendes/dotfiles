{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps:
      with ps; [
        ansible-lint
        micromamba
        shfmt
      ]);
  };
}
