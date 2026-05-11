{
  writeShellApplication,
  jq,
  json-diff,
}:
writeShellApplication {
  name = "noctalia-settings-diff";
  runtimeInputs = [
    jq
    json-diff
  ];
  text = ''
    SETTINGS_PATH="''${1:-$HOME/.config/noctalia/settings.json}"

    if [ ! -f "$SETTINGS_PATH" ]; then
      echo "Error: $SETTINGS_PATH not found" >&2
      exit 1
    fi

    RUNTIME_SETTINGS=$(noctalia-shell ipc call state all | jq -S .settings) || {
      echo "Error: Failed to get runtime settings. Is Noctalia running?" >&2
      exit 1
    }

    json-diff -C <(jq -S . "$SETTINGS_PATH") <(echo "$RUNTIME_SETTINGS") 2>/dev/null | grep -vP '^\x1b\[32m\+' || true
  '';
}
