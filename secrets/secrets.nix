let
  main = builtins.readFile ../dotfiles/ssh-keys/main.txt;
  server = builtins.readFile ../dotfiles/ssh-keys/server.txt;
  all_keys = [
    main
    server
  ];
in
{
  "claude-service-account.json.age".publicKeys = [ main ];
  "docker-compose.env.age".publicKeys = all_keys;
  "dozzle-users.yaml.age".publicKeys = all_keys;
  "gotify-server-upgrade-token.age".publicKeys = all_keys;
  "tailscale-authkey.age".publicKeys = all_keys;
  "transmission.json.age".publicKeys = all_keys;
}
