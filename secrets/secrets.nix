let
  main = builtins.readFile ../dotfiles/ssh-keys/main.txt;
  server = builtins.readFile ../dotfiles/ssh-keys/server.txt;
in

{
  "docker-compose-env.age".publicKeys = [
    main
    server
  ];
  "tailscale-tsdproxy-key.age".publicKeys = [
    main
    server
  ];
  "server-password.age".publicKeys = [ main ];
}
