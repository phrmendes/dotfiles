let
  main = builtins.readFile ../files/ssh/main.txt;
  server = builtins.readFile ../files/ssh/server.txt;
  laptop = builtins.readFile ../files/ssh/laptop.txt;
  allKeys = [
    main
    server
    laptop
  ];
in
{
  "users.yaml".publicKeys = allKeys;
  "authelia.yaml".publicKeys = allKeys;
  "beszel.age.env".publicKeys = allKeys;
  "caddy.age.env".publicKeys = allKeys;
  "dockerhub.age.json".publicKeys = allKeys;
  "duplicati.age.env".publicKeys = allKeys;
  "grafito.age.env".publicKeys = allKeys;
  "linkding.age.env".publicKeys = allKeys;
  "litestream.age.env".publicKeys = allKeys;
  "pi.age.json".publicKeys = allKeys;
  "sftpgo.age.env".publicKeys = allKeys;
  "transmission.age.json".publicKeys = allKeys;
}
