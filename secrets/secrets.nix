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
  "claude-service-account.age.json".publicKeys = allKeys;
  "cloudflare.age.env".publicKeys = allKeys;
  "deepseek.age.txt".publicKeys = allKeys;
  "dockerhub.age.json".publicKeys = allKeys;
  "duplicati.age.env".publicKeys = allKeys;
  "linkding.age.env".publicKeys = allKeys;
  "litestream.age.env".publicKeys = allKeys;
  "open-notebook.age.env".publicKeys = allKeys;
  "opencode.age.txt".publicKeys = allKeys;
  "surrealdb.age.env".publicKeys = allKeys;
  "telegram.age.env".publicKeys = allKeys;
}
