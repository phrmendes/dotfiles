{
  flake.modules.homeManager.starship = {
    programs = {
      bash.enable = true;
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        settings = {
          add_newline = false;
          format = "$username$hostname$directory$git_branch$git_status$line_break$character$cmd_duration";
          username = {
            format = "[$user]($style)@";
            style_user = "bold magenta";
          };
          hostname = {
            ssh_only = true;
            format = "[$hostname]($style) ";
            style = "bold magenta";
          };
          directory = {
            style = "bold cyan";
            truncation_length = 2;
            truncate_to_repo = false;
          };
          git_branch = {
            format = ''[\[$branch\]]($style) '';
            style = "purple";
          };
          git_status = {
            format = ''([\[$all_status$ahead_behind\]]($style) )'';
            style = "yellow";
          };
          cmd_duration = {
            min_time = 2000;
            format = "[$duration]($style) ";
            style = "yellow";
          };
          character = {
            success_symbol = "[λ](bold green)";
            error_symbol = "[λ](bold red)";
          };
        };
      };
    };
  };
}
