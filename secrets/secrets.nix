let
  phrmendes = builtins.readFile ../dotfiles/public-key.txt;
in
{

  "tailscale.age".publicKeys = [ phrmendes ];
}
