_: {
  modules.homeManager.dev.k8s =
    { pkgs, lib, ... }:
    let
      logBatPlugin =
        {
          scopes,
          extraArgs ? [ ],
        }:
        {
          shortCut = "Shift-L";
          description = "Logs (bat)";
          inherit scopes;
          command = "bash";
          background = false;
          args = [
            "-c"
            "\"$@\" | bat"
            "dummy-arg"
            "kubectl"
            "logs"
          ]
          ++ extraArgs
          ++ [
            "-n"
            "$NAMESPACE"
            "--context"
            "$CONTEXT"
            "--kubeconfig"
            "$KUBECONFIG"
          ];
        };
    in
    {
      home.packages = with pkgs; [
        kubectl
        kubernetes-helm
      ];

      programs.zsh.shellAliases.k = lib.getExe pkgs.kubectl;

      programs.k9s = {
        enable = true;
        settings.k9s.refreshRate = 1;
        plugins = {
          log-bat = logBatPlugin {
            scopes = [ "po" ];
            extraArgs = [ "$NAME" ];
          };
          log-bat-container = logBatPlugin {
            scopes = [ "containers" ];
            extraArgs = [
              "-c"
              "$NAME"
              "$POD"
            ];
          };
        };
      };
    };
}
