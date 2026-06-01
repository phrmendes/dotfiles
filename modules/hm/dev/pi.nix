{ config, ... }:
let
  inherit (config.settings) home;
  piDir = ../../../files/pi;
in
{
  modules.homeManager.dev.pi =
    { pkgs, osConfig, ... }:
    let
      agentHome = "${home}/.pi/agent";
      opencodeKey = "!cat ${osConfig.age.secrets."opencode.txt".path}";
      bifrostKey = "!cat ${osConfig.age.secrets."bifrost.txt".path}";
    in
    {
      home = {
        packages = with pkgs; [
          pi-coding-agent
          agent-browser
        ];

        sessionVariables = {
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          AGENT_BROWSER_SKILLS_DIR = "${pkgs.agent-browser}/skills";
        };

        file = {
          "${agentHome}/auth.json".text = builtins.toJSON {
            opencode-go = {
              type = "api_key";
              key = opencodeKey;
            };
            bifrost = {
              type = "api_key";
              key = bifrostKey;
            };
          };

          "${agentHome}/settings.json".text = builtins.toJSON {
            defaultProvider = "opencode-go";
            defaultModel = "deepseek-v4-pro";
            theme = "dark";
            skills = [ "${pkgs.agent-browser}/skills" ];
            compaction = {
              enabled = true;
              reserveTokens = 16384;
              keepRecentTokens = 20000;
            };
            retry = {
              enabled = true;
              maxRetries = 3;
            };
          };

          "${agentHome}/models.json".text = builtins.toJSON {
            providers = {
              bifrost = {
                baseUrl = "https://bifrost.local.ohlongjohnson.tech/v1";
                api = "openai-completions";
                apiKey = bifrostKey;
                models = [
                  {
                    id = "vertex/claude-sonnet-4-6@default";
                    name = "Claude Sonnet 4.6 (Vertex)";
                    reasoning = false;
                    input = [
                      "text"
                      "image"
                    ];
                    contextWindow = 200000;
                    maxTokens = 16000;
                    cost = {
                      input = 0;
                      output = 0;
                      cacheRead = 0;
                      cacheWrite = 0;
                    };
                  }
                  {
                    id = "deepseek/deepseek-chat";
                    name = "DeepSeek Chat";
                    reasoning = false;
                    input = [ "text" ];
                    contextWindow = 128000;
                    maxTokens = 8192;
                    cost = {
                      input = 0;
                      output = 0;
                      cacheRead = 0;
                      cacheWrite = 0;
                    };
                  }
                  {
                    id = "deepseek/deepseek-reasoner";
                    name = "DeepSeek Reasoner";
                    reasoning = true;
                    input = [ "text" ];
                    contextWindow = 128000;
                    maxTokens = 8192;
                    cost = {
                      input = 0;
                      output = 0;
                      cacheRead = 0;
                      cacheWrite = 0;
                    };
                  }
                ];
              };
            };
            profiles = {
              plan = "opencode-go/deepseek-v4-pro";
              dev = "opencode-go/deepseek-v4-flash";
              review = "opencode-go/deepseek-v4-pro";
              bugfix = "opencode-go/deepseek-v4-pro";
              guide = "opencode-go/deepseek-v4-flash";
            };
          };

          "${agentHome}/AGENTS.md".source = "${piDir}/AGENTS.md";
          "${agentHome}/extensions".source = "${piDir}/extensions";
          "${agentHome}/prompts".source = "${piDir}/prompts";
          "${agentHome}/skills".source = "${piDir}/skills";
        };
      };
    };
}
