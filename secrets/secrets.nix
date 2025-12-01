let
  main = builtins.readFile ../dotfiles/ssh-keys/main.txt;
  server = builtins.readFile ../dotfiles/ssh-keys/server.txt;
  laptop = builtins.readFile ../dotfiles/ssh-keys/laptop.txt;
  all_keys = [
    main
    server
    laptop
  ];
in
{
  "docker-compose.env.age".publicKeys = all_keys;
  "dozzle-users.yaml.age".publicKeys = all_keys;
  "tailscale-authkey.age".publicKeys = all_keys;
  "transmission.json.age".publicKeys = all_keys;
  "prunemate.json.age".publicKeys = all_keys;
  "claude-service-account.json.age".publicKeys = [
    main
    laptop
  ];
}
