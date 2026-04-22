_:
let
  litellm =
    { config, ... }:
    {
      users.groups.users.members = [ "litellm" ];

      services.litellm = {
        enable = true;
        host = "127.0.0.1";
        port = 14141;
        environmentFile = config.age.secrets."litellm.env".path;
        settings = {
          model_list = [
            {
              model_name = "claude-sonnet-4-5@20250929";
              litellm_params = {
                model = "vertex_ai/claude-sonnet-4-5@20250929";
              };
            }
          ];
          litellm_settings = {
            drop_params = true;
          };
        };
      };
    };
in
{
  modules.nixos = {
    workstation.litellm = litellm;
    server.litellm = litellm;
  };
}
