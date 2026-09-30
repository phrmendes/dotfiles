{
  homeModules.pi =
    { pkgs, config, ... }:
    let
      agentHome = "${config.home.homeDirectory}/.pi/agent";
      piDir = ../../files/pi;
      pyzotero = pkgs.python314Packages.pyzotero.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ [ pkgs.python314Packages.click ];
      });
    in
    {
      programs.pi-coding-agent = {
        enable = true;
        context = "${piDir}/AGENTS.md";
        extraPackages = with pkgs; [
          agent-browser
          jira-cli-go
          nushell
          pyzotero
        ];
        settings = {
          quietStartup = true;
          defaultProvider = "deepseek";
          defaultModel = "deepseek/deepseek-flash";
          theme = "dark";
          packages = [
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
            bifrost-openai = {
              name = "Bifrost (OpenAI)";
              baseUrl = "https://bifrost.iplan.dados.rio/openai/v1";
              api = "openai-completions";
              apiKey = "!nu -c 'open ${agentHome}/auth.json | get bifrost.key | into string'";
              compat = {
                supportsDeveloperRole = false;
                requiresReasoningContentOnAssistantMessages = true;
              };
              models = [
                {
                  id = "Huawei/deepseek-v4.1-flash";
                  name = "DeepSeek V4.1 Flash (Huawei)";
                  samplingParams = {
                    reasoning_effort = "low";
                  };
                  contextWindow = 1000000;
                  maxTokens = 384000;
                  input = [ "text" ];
                  reasoning = true;
                }
                {
                  id = "Huawei/deepseek-v4-flash";
                  name = "DeepSeek V4 Flash (Huawei)";
                  contextWindow = 1000000;
                  maxTokens = 384000;
                  input = [ "text" ];
                  reasoning = true;
                }
                {
                  id = "Huawei/deepseek-v4-pro";
                  name = "DeepSeek V4 Pro (Huawei)";
                  contextWindow = 1000000;
                  maxTokens = 128000;
                  input = [ "text" ];
                  reasoning = true;
                }
                {
                  id = "Huawei/glm-5.3";
                  name = "GLM-5.3 (Huawei)";
                  samplingParams = {
                    reasoning_effort = "low";
                  };
                  contextWindow = 1000000;
                  maxTokens = 128000;
                  input = [ "text" ];
                  reasoning = true;
                }
                {
                  id = "Huawei/glm-5.2";
                  name = "GLM-5.2 (Huawei)";
                  samplingParams = {
                    reasoning_effort = "low";
                  };
                  contextWindow = 1000000;
                  maxTokens = 128000;
                  input = [ "text" ];
                  reasoning = true;
                }
                {
                  id = "bedrock_mantle/openai.gpt-5.6-luna";
                  name = "GPT-5.6 Luna";
                  api = "openai-responses";
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
                  id = "bedrock_mantle/openai.gpt-5.6-terra";
                  name = "GPT-5.6 Terra";
                  api = "openai-responses";
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
                {
                  id = "bedrock_mantle/openai.gpt-5.6-sol";
                  name = "GPT-5.6 Sol";
                  api = "openai-responses";
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
              ];
            };
            bifrost-anthropic = {
              name = "Bifrost (Anthropic)";
              baseUrl = "https://bifrost.iplan.dados.rio/anthropic";
              api = "anthropic-messages";
              apiKey = "!nu -c 'open ${agentHome}/auth.json | get bifrost.key | into string'";
              models = [
                {
                  id = "claude-opus-5-5";
                  name = "Claude Opus 5.5";
                  contextWindow = 1000000;
                  maxTokens = 64000;
                  input = [
                    "text"
                    "image"
                  ];
                  reasoning = true;
                  headers = {
                    "anthropic-beta" = "context-1m-2025-08-07";
                  };
                }
                {
                  id = "claude-sonnet-5-5";
                  name = "Claude Sonnet 5.5";
                  contextWindow = 1000000;
                  maxTokens = 64000;
                  input = [
                    "text"
                    "image"
                  ];
                  reasoning = true;
                  headers = {
                    "anthropic-beta" = "context-1m-2025-08-07";
                  };
                }
              ];
            };
            bifrost-vertex = {
              name = "Bifrost (Vertex)";
              baseUrl = "https://bifrost.iplan.dados.rio/genai/v1beta";
              api = "google-generative-ai";
              apiKey = "!nu -c 'open ${agentHome}/auth.json | get bifrost.key | into string'";
              models = [
                {
                  id = "vertex/gemini-3.8-flash";
                  name = "Gemini 3.8 Flash";
                  contextWindow = 1048576;
                  maxTokens = 65536;
                  input = [
                    "text"
                    "image"
                  ];
                  reasoning = true;
                }
              ];
            };
          };
        };
      };

      home = {
        file = {
          "${agentHome}/skills".source = "${piDir}/skills";
          ".config/.jira/.config.yml".source = ../../files/jira.yaml;
        };
      };
    };
}
