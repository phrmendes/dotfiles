{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps:
      with ps; [
        alejandra
        ansible-lint
        nixd
        shfmt
      ]);
  };
}
