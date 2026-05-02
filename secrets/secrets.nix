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
  "beszel-agent.env.age".publicKeys = allKeys;
  "claude-service-account.json.age".publicKeys = allKeys;
  "docker-compose.env.age".publicKeys = allKeys;
  "docker-config.json.age".publicKeys = allKeys;

  "gh-hosts.yaml.age".publicKeys = allKeys;
  "opencode.txt.age".publicKeys = allKeys;
  "prunemate.json.age".publicKeys = allKeys;
  "transmission.json.age".publicKeys = allKeys;
}
