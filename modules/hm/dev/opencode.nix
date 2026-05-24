{ config, ... }:
let
  inherit (config.settings) home;
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
    "research"
    "guide"
    "lua"
  ];
  commands = readPrompts "commands" [ "bugfix" ];
in
{
  modules.homeManager.dev.opencode =
    { pkgs, osConfig, ... }:
    let
      agentBrowserSkill = builtins.readFile "${pkgs.agent-browser}/skills/agent-browser/SKILL.md";

      opencode-wrapped = pkgs.writeShellApplication {
        name = "opencode";
        runtimeInputs = with pkgs; [
          agent-browser
          opencode
        ];
        text = ''
          exec env \
            AGENT_BROWSER_EXECUTABLE_PATH="${pkgs.ungoogled-chromium}/bin/chromium" \
            AGENT_BROWSER_SKILLS_DIR="${pkgs.agent-browser}/skills" \
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
            "bifrost"
            "github-copilot"
          ];
          model = "opencode-go/qwen3.5-plus";
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
            bifrost = {
              options = {
                apiKey = "{file:${osConfig.age.secrets."bifrost.txt".path}}";
                baseURL = "https://bifrost.local.ohlongjohnson.tech";
              };
              models = {
                "vertex/claude-sonnet-4-6@default".name = "Claude Sonnet 4.6 (Vertex)";
                "deepseek/deepseek-chat".name = "DeepSeek Chat";
                "deepseek/deepseek-reasoner".name = "DeepSeek Reasoner";
              };
            };
          };
        };
      };
    };
}
