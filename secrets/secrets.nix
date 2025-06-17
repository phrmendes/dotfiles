let
  phrmendes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN37XVwvA/xQHxcFBdFO97gJZX0JwPp4tMP0sbRpsZfZ pedrohrmendes@proton.me";
in
{

  "tailscale.age".publicKeys = [ phrmendes ];
}
