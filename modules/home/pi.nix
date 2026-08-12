{
  homeModules.pi =
    { pkgs, config, ... }:
    let
      agentHome = "${config.home.homeDirectory}/.pi/agent";
      piDir = ../../files/pi;
    in
    {
      programs.pi-coding-agent = {
        enable = true;
        context = "${piDir}/AGENTS.md";
        extraPackages = with pkgs; [
          agent-browser
          jira-cli-go
        ];
        settings = {
          quietStartup = true;
          defaultProvider = "deepseek";
          defaultModel = "deepseek/deepseek-v4-flash";
          theme = "dark";
          packages = [
            "npm:pi-tuicr"
            "git:github.com/phrmendes/pi-plan-mode"
          ];
          skills = [
            "${pkgs.agent-browser}/skills"
            "${piDir}/skills"
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
        models = {
          providers = {
            bifrost = {
              name = "Bifrost";
              baseUrl = "https://bifrost.iplan.dados.rio/anthropic";
              api = "anthropic-messages";
              apiKey = "!${pkgs.jq}/bin/jq -r '.bifrost.key' ${agentHome}/auth.json";
              models = [
                {
                  id = "claude-sonnet-5";
                  name = "Claude Sonnet 5";
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
                {
                  id = "openai.gpt-5.6-luna";
                  name = "GPT-5.6 Luna";
                  contextWindow = 1050000;
                  maxTokens = 128000;
                  input = [
                    "text"
                    "image"
                  ];
                  reasoning = true;
                  cost = {
                    input = 0.1;
                    output = 0.6;
                    cacheRead = 0.01;
                    cacheWrite = 0.125;
                  };
                }
                {
                  id = "openai.gpt-5.6-sol";
                  name = "GPT-5.6 Sol";
                  contextWindow = 1050000;
                  maxTokens = 128000;
                  input = [
                    "text"
                    "image"
                  ];
                  reasoning = true;
                  cost = {
                    input = 0.25;
                    output = 1.5;
                    cacheRead = 0.025;
                    cacheWrite = 0.3125;
                  };
                }
                {
                  id = "openai.gpt-5.6-terra";
                  name = "GPT-5.6 Terra";
                  contextWindow = 1050000;
                  maxTokens = 128000;
                  input = [
                    "text"
                    "image"
                  ];
                  reasoning = true;
                  cost = {
                    input = 0.5;
                    output = 3;
                    cacheRead = 0.05;
                    cacheWrite = 0.625;
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
                    input = 0.435;
                    output = 0.87;
                    cacheRead = 0.003625;
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
                    cacheRead = 0.0028;
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
      };

      home = {
        sessionVariables = {
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          PI_CACHE_RETENTION = "long";
          PI_SKIP_VERSION_CHECK = "1";
        };
        file = {
          "${agentHome}/skills".source = "${piDir}/skills";
          ".config/.jira/.config.yml".source = ../../files/jira.yaml;
        };
      };
    };
}
