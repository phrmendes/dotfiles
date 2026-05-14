{ config, ... }:
let
  inherit (config.settings) gcp;
  inherit (config.settings.gcp) maasEndpoint;
  inherit (config.settings) litellmPort;
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

      vertexMaaSProvider = region: name: models: {
        npm = "@ai-sdk/openai-compatible";
        inherit name;
        options = {
          baseURL = maasEndpoint region;
          apiKey = "{env:VERTEX_MAAS_TOKEN}";
        };
        inherit models;
      };

      opencode-wrapped = pkgs.writeShellApplication {
        name = "opencode";
        runtimeInputs = [
          pkgs.opencode
          pkgs.local.gcp-token
        ];
        text = ''
          VERTEX_MAAS_TOKEN="$(GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" gcp-token)"
          exec env \
            CHROME_PATH="${pkgs.ungoogled-chromium}/bin/chromium" \
            GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" \
            GOOGLE_VERTEX_PROJECT="${gcp.project}" \
            GOOGLE_VERTEX_LOCATION="${gcp.location}" \
            PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
            VERTEX_MAAS_TOKEN="$VERTEX_MAAS_TOKEN" \
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
          skills
          commands
          ;

        settings = {
          agent.build.disable = true;
          enabled_providers = [
            "opencode-go"
            "google-vertex-anthropic"
            "google-vertex"
            "vertex-maas-global"
            "vertex-maas-us-south1"
          ];
          model = "opencode-go/deepseek-v4-pro";
          small_model = "opencode-go/qwen3.5-plus";
          mcp = {
            k8s = {
              type = "local";
              command = [ "${pkgs.mcp-k8s-go}/bin/mcp-k8s-go" ];
              enabled = true;
            };
            playwright = {
              type = "local";
              command = [ "${pkgs.playwright-mcp}/bin/playwright-mcp" ];
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
                "glm-5.1".name = "GLM 5.1";
                "deepseek-v4-pro".name = "DeepSeek V4 Pro";
                "deepseek-v4-flash".name = "DeepSeek V4 Flash";
              };
            };
            google-vertex-anthropic = {
              models."claude-sonnet-4-6@default" = { };
            };
            google-vertex = {
              options.location = "global";
              models."gemini-3.1-pro-preview".name = "Gemini 3.1 Pro Preview";
            };
            vertex-maas-global = vertexMaaSProvider "global" "Vertex (Global)" {
              "deepseek-ai/deepseek-v3.2-maas".name = "DeepSeek V3.2";
              "moonshotai/kimi-k2-thinking-maas".name = "Kimi K2 Thinking";
              "qwen/qwen3-next-80b-a3b-instruct-maas".name = "Qwen3 Next 80B Instruct";
              "qwen/qwen3-next-80b-a3b-thinking-maas".name = "Qwen3 Next 80B Thinking";
            };
            vertex-maas-us-south1 = vertexMaaSProvider "us-south1" "Vertex (US South1)" {
              "qwen/qwen3-coder-480b-a35b-instruct-maas".name = "Qwen3 Coder 480B";
              "qwen/qwen3-235b-a22b-instruct-2507-maas".name = "Qwen3 235B Instruct";
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
          VERTEX_CLAUDE_API_KEY="$(GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" gcp-token)"
          OPENCODE_API_KEY="$(cat ${opencode-key})"
          exec env \
            GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" \
            VERTEX_CLAUDE_API_KEY="$VERTEX_CLAUDE_API_KEY" \
            OPENCODE_API_KEY="$OPENCODE_API_KEY" \
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
              vertex-maas = {
                api = "openai-completions";
                baseUrl = "${litellmUrl}/v1";
                apiKey = "VERTEX_CLAUDE_API_KEY";
                models = [
                  {
                    id = "qwen3-coder-480b";
                    name = "Qwen3 Coder 480B";
                    contextWindow = 262144;
                    maxTokens = 16384;
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
