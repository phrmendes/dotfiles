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
      jiraApiToken = osConfig.age.secrets."jira.txt".path;
      jira-wrapped = pkgs.writeShellScriptBin "jira" ''
        export JIRA_API_TOKEN="$(cat ${jiraApiToken})"
        exec ${pkgs.jira-cli-go}/bin/jira "$@"
      '';
    in
    {
      home = {
        packages =
          with pkgs;
          [
            agent-browser
            jira-wrapped
            pi-coding-agent
          ]
          ++ [
            pkgs.local.agent-tasks
          ];

        sessionVariables = {
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          AGENT_BROWSER_SKILLS_DIR = "${pkgs.agent-browser}/skills";
          PI_CACHE_RETENTION = "long";
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
            defaultProvider = "bifrost";
            defaultModel = "deepseek/deepseek-v4-flash";
            theme = "dark";
            skills = [
              "${pkgs.agent-browser}/skills"
              "${pkgs.local.agent-tasks}/skills"
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
                    contextWindow = 1000000;
                    maxTokens = 16000;
                    cost = {
                      input = 3;
                      output = 15;
                      cacheRead = 0.3;
                      cacheWrite = 3.75;
                    };
                  }
                  {
                    id = "vertex/z-ai/glm-5.1";
                    name = "GLM 5.1 (Vertex)";
                    reasoning = false;
                    input = [
                      "text"
                      "image"
                    ];
                    contextWindow = 200000;
                    maxTokens = 128000;
                    cost = {
                      input = 0;
                      output = 0;
                      cacheRead = 0;
                      cacheWrite = 0;
                    };
                  }
                  {
                    id = "deepseek/deepseek-chat";
                    name = "DeepSeek Chat (compaction)";
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
                    id = "deepseek/deepseek-v4-flash";
                    name = "DeepSeek V4 Flash";
                    reasoning = true;
                    input = [ "text" ];
                    contextWindow = 1000000;
                    maxTokens = 32768;
                    cost = {
                      input = 0.14;
                      output = 0.28;
                      cacheRead = 0.0028;
                      cacheWrite = 0;
                    };
                  }
                  {
                    id = "deepseek/deepseek-v4-pro";
                    name = "DeepSeek V4 Pro";
                    reasoning = true;
                    input = [ "text" ];
                    contextWindow = 1000000;
                    maxTokens = 32768;
                    cost = {
                      input = 0.435;
                      output = 0.87;
                      cacheRead = 0.003625;
                      cacheWrite = 0;
                    };
                  }
                ];
              };
            };
            profiles = {
              plan = "bifrost/deepseek/deepseek-v4-pro";
              dev = "bifrost/deepseek/deepseek-v4-flash";
              review = "bifrost/deepseek/deepseek-v4-flash";
              guide = "bifrost/deepseek/deepseek-v4-flash";
            };
          };

          "${agentHome}/AGENTS.md".source = "${piDir}/AGENTS.md";
          "${agentHome}/extensions".source = "${piDir}/extensions";
          "${agentHome}/prompts".source = "${piDir}/prompts";
          "${agentHome}/skills".source = "${piDir}/skills";

          ".config/.jira/.config.yml".text = ''
            installation: cloud
            server: https://iplanrio-pcrj.atlassian.net
            login: pedro.hrmendes@prefeitura.rio
            project: INFRAVPIA
            board:
              id: 1
              name: Board Name
            issue:
              types:
                - name: Iniciativa
                  handle: Iniciativa
                - name: Epic
                  handle: Epic
                - name: História
                  handle: História
                - name: Nova Feature
                  handle: Nova Feature
                - name: Melhoria
                  handle: Melhoria
                - name: Ajuste
                  handle: Ajuste
                - name: Bug
                  handle: Bug
                - name: Débito técnico
                  handle: Débito técnico
                - name: Incidente
                  handle: Incidente
                - name: Estudo/Mapeamento
                  handle: Estudo/Mapeamento
                - name: Validação de hipótese
                  handle: Validação de hipótese
                - name: Spike
                  handle: Spike
                - name: Subtarefa
                  handle: Subtarefa
          '';
        };
      };
    };
}
