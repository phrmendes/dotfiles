{ writeShellApplication, google-cloud-sdk }:
writeShellApplication {
  name = "gcp-token";
  runtimeInputs = [ google-cloud-sdk ];
  text = ''
    gcloud auth application-default print-access-token
  '';
}
