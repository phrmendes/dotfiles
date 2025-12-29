{ config, lib, ... }:
{
  options.k9s.enable = lib.mkEnableOption "enable k9s";

  config = lib.mkIf config.k9s.enable {
    programs.k9s = {
      enable = true;
      settings = {
        k9s = {
          refreshRate = 1;
        };
      };
      plugins = {
        log-bat = {
          shortCut = "Shift-L";
          description = "Logs (bat)";
          scopes = [ "po" ];
          command = "bash";
          background = false;
          args = [
            "-c"
            "\"$@\" | bat"
            "dummy-arg"
            "kubectl"
            "logs"
            "$NAME"
            "-n"
            "$NAMESPACE"
            "--context"
            "$CONTEXT"
            "--kubeconfig"
            "$KUBECONFIG"
          ];
        };
        log-bat-container = {
          shortCut = "Shift-L";
          description = "Logs (bat)";
          scopes = [ "containers" ];
          command = "bash";
          background = false;
          args = [
            "-c"
            "\"$@\" | bat"
            "dummy-arg"
            "kubectl"
            "logs"
            "-c"
            "$NAME"
            "$POD"
            "-n"
            "$NAMESPACE"
            "--context"
            "$CONTEXT"
            "--kubeconfig"
            "$KUBECONFIG"
          ];
        };
      };
    };
  };
}
