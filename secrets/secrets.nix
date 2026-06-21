let
  main = builtins.readFile ../files/ssh-keys/main.txt;
  server = builtins.readFile ../files/ssh-keys/server.txt;
  laptop = builtins.readFile ../files/ssh-keys/laptop.txt;
  allKeys = [
    main
    server
    laptop
  ];
in
{
  "beszel.age.env".publicKeys = allKeys;
  "caddy.age.env".publicKeys = allKeys;
  "dockerhub.age.json".publicKeys = allKeys;
  "duplicati.age.env".publicKeys = allKeys;
  "linkding.age.env".publicKeys = allKeys;
  "litestream.age.env".publicKeys = allKeys;
  "pi.age.json".publicKeys = allKeys;
  "telegram.age.env".publicKeys = allKeys;
  "transmission.age.json".publicKeys = allKeys;
}
