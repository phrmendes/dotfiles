{ config, ... }:
let
  inherit (config.settings) gcp;
  inherit (config.settings) litellmPort;
  inherit (config.settings) home;
  inherit (config.settings.lan) containerHostAddress;
  litellmUrl = "http://${containerHostAddress}:${toString litellmPort}";
  promptsDir = ../../../files/prompts;
  readPrompts =
    group: names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = builtins.readFile "${promptsDir}/${group}/${name}.md";
      }) names
    );
  context = builtins.readFile "${promptsDir}/context.md";
  agents = readPrompts "agents" [
    "plan"
    "dev"
    "review"
  ];
  skills = readPrompts "skills" [
    "python"
    "elixir"
    "typescript"
    "devops"
  ];
  commands = readPrompts "commands" [ "bugfix" ];
in
{
  modules.homeManager.dev.opencode =
    { pkgs, osConfig, ... }:
    let
      keyfile = osConfig.age.secrets."claude-service-account.json".path;

      agentBrowserSkill = builtins.readFile "${pkgs.agent-browser}/share/agent-browser/skills/agent-browser/SKILL.md";

      opencode-wrapped = pkgs.writeShellApplication {
        name = "opencode";
        runtimeInputs = with pkgs; [
          agent-browser
          opencode
          local.gcp-token
        ];
        text = ''
          exec env \
            AGENT_BROWSER_EXECUTABLE_PATH="${pkgs.ungoogled-chromium}/bin/chromium" \
            AGENT_BROWSER_SKILLS_DIR="${pkgs.agent-browser}/share/agent-browser/skills" \
            GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" \
            GOOGLE_VERTEX_PROJECT="${gcp.project}" \
            GOOGLE_VERTEX_LOCATION="${gcp.location}" \
            opencode "$@"
        '';
      };
    in
    {
      programs.opencode = {
        package = opencode-wrapped;
        enable = true;
        enableMcpIntegration = true;

        inherit
          context
          agents
          commands
          ;

        skills = skills // {
          agent-browser = agentBrowserSkill;
        };

        settings = {
          agent.build.disable = true;
          enabled_providers = [
            "opencode-go"
            "google-vertex-anthropic"
            "github-copilot"
          ];
          model = "opencode-go/deepseek-v4-pro";
          small_model = "opencode-go/qwen3.5-plus";
          mcp = {
            k8s = {
              type = "local";
              command = [ "${pkgs.mcp-k8s-go}/bin/mcp-k8s-go" ];
              environment.GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
              enabled = true;
            };
            jira = {
              type = "remote";
              url = "https://mcp.atlassian.com/v1/mcp";
              enabled = true;
            };
            nixos = {
              type = "local";
              command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
              enabled = true;
            };
            memory = {
              type = "local";
              command = [ "${pkgs.mcp-server-memory}/bin/mcp-server-memory" ];
              environment.MEMORY_FILE_PATH = "${home}/.local/share/opencode/memory.jsonl";
              enabled = true;
            };
          };
          provider = {
            opencode-go = {
              options.apiKey = "{file:${osConfig.age.secrets."opencode.txt".path}}";
              models = {
                "kimi-k2.5".name = "Kimi K2.5";
                "kimi-k2.6".name = "Kimi K2.6";
                "qwen3.5-plus".name = "Qwen3.5 Plus";
                "qwen3.6-plus".name = "Qwen3.6 Plus";
                "glm-5".name = "GLM 5";
                "glm-5.1".name = "GLM 5.1";
                "deepseek-v4-pro".name = "DeepSeek V4 Pro";
                "deepseek-v4-flash".name = "DeepSeek V4 Flash";
              };
            };
            google-vertex-anthropic = {
              models."claude-sonnet-4-6@default" = { };
            };
          };
        };
      };
    };

  modules.homeManager.dev.pi =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    let
      keyfile = osConfig.age.secrets."claude-service-account.json".path;
      opencode-key = osConfig.age.secrets."opencode.txt".path;

      pi-wrapped = pkgs.writeShellApplication {
        name = "pi";
        runtimeInputs = [
          pkgs.local.gcp-token
          pkgs.pi-coding-agent
        ];
        text = ''
          exec env \
            VERTEX_CLAUDE_API_KEY="$(GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" gcp-token)" \
            OPENCODE_API_KEY="$(cat ${opencode-key})" \
            pi "$@"
        '';
      };

      skillFiles =
        skills
        |> lib.mapAttrs' (
          name: content: lib.nameValuePair ".pi/agent/skills/${name}/SKILL.md" { text = content; }
        );

      promptFiles =
        agents
        |> lib.mapAttrs' (
          name: content: lib.nameValuePair ".pi/agent/prompts/${name}.md" { text = content; }
        );
    in
    {
      home.packages = [ pi-wrapped ];

      home.file =
        skillFiles
        // promptFiles
        // {
          ".pi/agent/AGENTS.md".text = context;

          ".pi/agent/models.json".text = builtins.toJSON {
            providers = {
              vertex-claude = {
                api = "anthropic-messages";
                baseUrl = litellmUrl;
                apiKey = "VERTEX_CLAUDE_API_KEY";
                models = [
                  {
                    id = "claude-sonnet-4-6@default";
                    name = "Claude Sonnet 4.6 (Vertex)";
                    contextWindow = 200000;
                    maxTokens = 8192;
                    reasoning = false;
                    input = [ "text" ];
                  }
                ];
              };
            };
          };

          ".pi/agent/settings.json".text = builtins.toJSON {
            defaultProvider = "vertex-claude";
            defaultModel = "claude-sonnet-4-6@default";
          };
        };
    };
}
