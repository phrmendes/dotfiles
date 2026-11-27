let
  desktop = builtins.readFile ./files/ssh/desktop.txt;
  server = builtins.readFile ./files/ssh/server.txt;
  laptop = builtins.readFile ./files/ssh/laptop.txt;
  deck = builtins.readFile ./files/ssh/deck.txt;
  serverRecipients = [
    desktop
    server
  ];
  laptopRecipients = [
    desktop
    laptop
  ];
  sharedRecipients = [
    desktop
    laptop
    deck
  ];
in
{
  "secrets/authelia.age.yaml".publicKeys = serverRecipients;
  "secrets/beszel.age.env".publicKeys = serverRecipients;
  "secrets/ca.age.key".publicKeys = serverRecipients;
  "secrets/ddclient.age.txt".publicKeys = serverRecipients;
  "secrets/dockerhub.age.json".publicKeys = serverRecipients;
  "secrets/linkding.age.env".publicKeys = serverRecipients;
  "secrets/miniflux.age.env".publicKeys = serverRecipients;
  "secrets/noctalia.age.txt".publicKeys = laptopRecipients;
  "secrets/pi.age.json".publicKeys = sharedRecipients;
  "secrets/restic.age.env".publicKeys = serverRecipients;
  "secrets/searxng.age.env".publicKeys = serverRecipients;
  "secrets/sftpgo.age.env".publicKeys = serverRecipients;
  "secrets/shelfmark.age.env".publicKeys = serverRecipients;
  "secrets/users.age.yaml".publicKeys = serverRecipients;
  "secrets/wg.laptop.age.conf".publicKeys = laptopRecipients;
}
