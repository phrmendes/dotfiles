let
  desktop = builtins.readFile ./files/ssh/desktop.txt;
  server = builtins.readFile ./files/ssh/server.txt;
  laptop = builtins.readFile ./files/ssh/laptop.txt;
  deck = builtins.readFile ./files/ssh/deck.txt;
in
{
  "secrets/authelia.age.yaml".publicKeys = [
    desktop
    server
  ];
  "secrets/beszel.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/ca.age.key".publicKeys = [
    desktop
    server
  ];
  "secrets/ddclient.age.txt".publicKeys = [
    desktop
    server
  ];
  "secrets/dockerhub.age.json".publicKeys = [
    desktop
    server
  ];
  "secrets/linkding.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/miniflux.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/noctalia.age.txt".publicKeys = [
    desktop
    laptop
  ];
  "secrets/pi.age.json".publicKeys = [
    desktop
    laptop
    deck
  ];
  "secrets/restic.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/searxng.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/sftpgo.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/shelfmark.age.env".publicKeys = [
    desktop
    server
  ];
  "secrets/users.age.yaml".publicKeys = [
    desktop
    server
  ];
  "secrets/wg.deck.age.conf".publicKeys = [
    desktop
    deck
  ];
  "secrets/wg.laptop.age.conf".publicKeys = [
    desktop
    laptop
  ];
}
