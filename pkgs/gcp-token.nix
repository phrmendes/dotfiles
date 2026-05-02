{ writeShellApplication, google-cloud-sdk }:
writeShellApplication {
  name = "gcp-token";
  runtimeInputs = [ google-cloud-sdk ];
  text = ''
    if [[ -n "''${GOOGLE_APPLICATION_CREDENTIALS:-}" ]]; then
      gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS" --quiet 2>/dev/null
    fi

    gcloud auth print-access-token
  '';
}
