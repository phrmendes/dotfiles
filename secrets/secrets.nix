let
  main = builtins.readFile ../dotfiles/ssh-keys/main.txt;
  server = builtins.readFile ../dotfiles/ssh-keys/server.txt;
in

{
  "server-password.age".publicKeys = [ main ];
  "docker-compose-env.age".publicKeys = [
    main
    server
  ];
}
