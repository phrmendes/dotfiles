let
  main = builtins.readFile ./files/ssh/main.txt;
  server = builtins.readFile ./files/ssh/server.txt;
  laptop = builtins.readFile ./files/ssh/laptop.txt;
  mkSecrets =
    publicKeys: files:
    builtins.listToAttrs (
      map (name: {
        name = "secrets/${name}";
        value.publicKeys = publicKeys;
      }) files
    );
in
mkSecrets
  [ main server ]
  [
    "authelia.age.yaml"
    "beszel.age.env"
    "ca.age.key"
    "dockerhub.age.json"
    "linkding.age.env"
    "miniflux.age.env"
    "restic.age.env"
    "searxng.age.env"
    "sftpgo.age.env"
    "users.age.yaml"
  ]
# Workstation secrets: the laptop key decrypts them, the server key does not.
//
  mkSecrets
    [ main laptop ]
    [
      "noctalia.age.txt"
      "pi.age.json"
      "wg.laptop.age.conf"
    ]
