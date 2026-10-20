let
  main = builtins.readFile ../files/ssh/main.txt;
  server = builtins.readFile ../files/ssh/server.txt;
  laptop = builtins.readFile ../files/ssh/laptop.txt;
  mkSecrets =
    files:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value.publicKeys = [
          main
          server
          laptop
        ];
      }) files
    );
in
mkSecrets [
  "authelia.age.yaml"
  "beszel.age.env"
  "ca.age.key"
  "dockerhub.age.json"
  "linkding.age.env"
  "miniflux.age.env"
  "noctalia.age.txt"
  "pi.age.json"
  "restic.age.env"
  "searxng.age.env"
  "sftpgo.age.env"
  "users.age.yaml"
  "wg-easy.age.env"
]
