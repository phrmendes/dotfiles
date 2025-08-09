{
  config,
  lib,
  parameters,
  pkgs,
  ...
}:
{
  options.screenrecorder.enable = lib.mkEnableOption "enable screenrecorder";

  config = lib.mkIf config.screenrecorder.enable {
    home = {
      packages = with pkgs; [
        (writeShellScriptBin "screenrecorder" ''
          #!/usr/bin/env bash

          if [[ "$1" == "--audio" ]]; then
            ${wf-recorder}/bin/wf-recorder -g "$(${slurp}/bin/slurp)" --audio --file "${parameters.home}/Videos/screenrecord-$(date +%Y%m%d%H%M%S).mp4"
          else
            ${wf-recorder}/bin/wf-recorder -g "$(${slurp}/bin/slurp)" --file "${parameters.home}/Videos/screenrecord-$(date +%Y%m%d%H%M%S).mp4"
          fi
        '')
      ];
    };

  };
}
