{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false; # Fish has its own prompt
    enableBashIntegration = false;

    settings = {
      format = "$directory$git_branch$git_status$nix_shell$line_break$character";
      right_format = "$status$cmd_duration";
      add_newline = true;

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold blue";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold yellow";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold red";
      };

      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      status = {
        disabled = false;
        format = "[$status]($style) ";
        style = "bold red";
      };

      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style)";
        style = "bold yellow";
      };
    };
  };
}
