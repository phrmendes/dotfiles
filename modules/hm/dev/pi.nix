{ config, ... }:
{
  modules.homeManager.dev.pi =
    { pkgs, config, ... }:
    let
      agentHome = "${config.home.homeDirectory}/.pi/agent";
      piDir = ../../../files/pi;
    in
    {
      home = {
        packages = with pkgs; [
          agent-browser
          jira-cli-go
          pi-coding-agent
        ];

        sessionVariables = {
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          AGENT_BROWSER_SKILLS_DIR = "${pkgs.agent-browser}/skills";
          PI_CACHE_RETENTION = "long";
        };

        file = {
          "${agentHome}/settings.json".text = builtins.toJSON {
            defaultProvider = "deepseek";
            defaultModel = "deepseek/deepseek-v4-flash";
            theme = "dark";
            skills = [
              "${pkgs.agent-browser}/skills"
            ];
            compaction = {
              enabled = true;
              reserveTokens = 16384;
              keepRecentTokens = 12000;
            };
            thinkingBudgets = {
              minimal = 1024;
              low = 4096;
              medium = 8192;
              high = 16384;
            };
            retry = {
              enabled = true;
              maxRetries = 3;
            };
          };

          "${agentHome}/models.json".text = builtins.toJSON {
            providers = {
              bifrost = {
                name = "Bifrost";
                baseUrl = "https://bifrost.iplan.dados.rio/anthropic";
                api = "anthropic-messages";
                apiKey = "!${pkgs.jq}/bin/jq -r '.bifrost.key' ${agentHome}/auth.json";
                models = [
                  {
                    id = "claude-sonnet-4-6";
                    name = "Claude Sonnet 4";
                    contextWindow = 200000;
                    maxTokens = 16384;
                    input = [
                      "text"
                      "image"
                    ];
                    reasoning = true;
                    cost = {
                      input = 3;
                      output = 15;
                      cacheRead = 0.3;
                      cacheWrite = 3.75;
                    };
                  }
                ];
              };
              deepseek = {
                baseUrl = "https://api.deepseek.com";
                api = "openai-completions";
                models = [
                  {
                    id = "deepseek-v4-pro";
                    name = "DeepSeek V4 Pro";
                    contextWindow = 1000000;
                    maxTokens = 384000;
                    input = [ "text" ];
                    reasoning = true;
                    cost = {
                      input = 1.74;
                      output = 3.48;
                      cacheRead = 0.145;
                      cacheWrite = 0;
                    };
                    compat = {
                      requiresReasoningContentOnAssistantMessages = true;
                      thinkingFormat = "deepseek";
                      reasoningEffortMap = {
                        minimal = "high";
                        low = "high";
                        medium = "high";
                        high = "high";
                        xhigh = "max";
                      };
                    };
                  }
                  {
                    id = "deepseek-v4-flash";
                    name = "DeepSeek V4 Flash";
                    contextWindow = 1000000;
                    maxTokens = 384000;
                    input = [ "text" ];
                    reasoning = true;
                    cost = {
                      input = 0.14;
                      output = 0.28;
                      cacheRead = 0.028;
                      cacheWrite = 0;
                    };
                    compat = {
                      requiresReasoningContentOnAssistantMessages = true;
                      thinkingFormat = "deepseek";
                      reasoningEffortMap = {
                        minimal = "high";
                        low = "high";
                        medium = "high";
                        high = "high";
                        xhigh = "max";
                      };
                    };
                  }
                ];
              };
            };
          };

          "${agentHome}/AGENTS.md".source = "${piDir}/AGENTS.md";
          "${agentHome}/extensions".source = "${piDir}/extensions";
          "${agentHome}/prompts".source = "${piDir}/prompts";
          "${agentHome}/skills".source = "${piDir}/skills";
          ".config/.jira/.config.yml".source = ../../../files/jira.yaml;
        };
      };
    };
}
