let
  main = builtins.readFile ../dotfiles/ssh-keys/main.txt;
  server = builtins.readFile ../dotfiles/ssh-keys/server.txt;
  all_keys = [
    main
    server
  ];
in
{
  "docker-compose.env.age".publicKeys = all_keys;
  "hashed-password.age".publicKeys = all_keys;
  "tailscale-authkey.age".publicKeys = all_keys;
  "transmission.json.age".publicKeys = all_keys;
}
