let
  main = builtins.readFile ../files/ssh-keys/main.txt;
  server = builtins.readFile ../files/ssh-keys/server.txt;
  laptop = builtins.readFile ../files/ssh-keys/laptop.txt;
  all_keys = [
    main
    server
    laptop
  ];
in
{
  "claude-service-account.json.age".publicKeys = all_keys;
  "docker-compose.env.age".publicKeys = all_keys;
  "docker-config.json.age".publicKeys = all_keys;
  "dozzle-users.yaml.age".publicKeys = all_keys;
  "gh-hosts.yaml.age".publicKeys = all_keys;
  "litellm.env.age".publicKeys = all_keys;
  "opencode.txt.age".publicKeys = all_keys;
  "prunemate.json.age".publicKeys = all_keys;
  "transmission.json.age".publicKeys = all_keys;
}
