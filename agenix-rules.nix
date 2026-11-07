let
  main = builtins.readFile ./files/ssh/main.txt;
  keys = {
    server = builtins.readFile ./files/ssh/server.txt;
    laptop = builtins.readFile ./files/ssh/laptop.txt;
  };

  # The directory a secret sits in decides who can decrypt it, so the
  # recipients cannot drift from the files on disk.
  secretsIn =
    dir: publicKeys:
    let
      base = ./secrets + "/${dir}";
      entries = builtins.readDir base;
      names = builtins.filter (name: entries.${name} == "regular") (builtins.attrNames entries);
    in
    builtins.listToAttrs (
      map (name: {
        name = "secrets/${dir}${name}";
        value.publicKeys = publicKeys;
      }) names
    );
in
secretsIn "" [
  main
  keys.server
]
// secretsIn "laptop/" [
  main
  keys.laptop
]
