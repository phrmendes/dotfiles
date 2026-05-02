{ writeShellApplication }:
writeShellApplication {
  name = "wait-for-age-secrets";
  text = ''
    deadline=$((SECONDS + 60))
    until
      all_present=true
      for path in "$@"; do
        [ -f "$path" ] || { all_present=false; break; }
      done
      $all_present
    do
      [ $SECONDS -lt $deadline ] || { echo "Timed out waiting for age secrets" >&2; exit 1; }
      sleep 1
    done
  '';
}
