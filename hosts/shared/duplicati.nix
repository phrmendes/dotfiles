{ parameters, ... }:
{
  services.duplicati = {
    inherit (parameters) user;
    enable = true;
  };
}
