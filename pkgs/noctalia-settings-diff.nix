{
  writeShellApplication,
}:
writeShellApplication {
  name = "noctalia-settings-diff";
  meta.mainProgram = "noctalia-settings-diff";
  text = ''
    CONFIG="$HOME/.config/noctalia/config.toml"
    STATE="$HOME/.local/state/noctalia/settings.toml"

    if [ ! -f "$STATE" ]; then
      echo "No runtime state file at $STATE"
      exit 1
    fi

    echo "=== Runtime overrides (state) vs base config ==="
    echo "State: $STATE"
    echo "Config: $CONFIG"
    echo "---"
    diff -u "$CONFIG" "$STATE" 2>/dev/null || true
  '';
}
