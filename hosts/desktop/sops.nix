{parameters, ...}: {
  sops = {
    defaultSopsFile = "../../secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${parameters.users}/.config/sops/age/keys.txt";
    secrets.sudo.neededForUsers = true;
  };
}
