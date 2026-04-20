{ config, ... }:

let
  # nixpalette → Stylix resolves the active theme and exposes its base16
  # palette here.  Every color below tracks the live theme automatically.
  c = config.lib.stylix.colors;

  # Semantic color roles (mirrors overrides.terminal in the theme files):
  #   base0B → success / green
  #   base08 → error / red
  #   base0D → directory / blue / functions
  #   base09 → git-branch / orange / constants
  #   base0E → nix-shell / purple / keywords
  #   base0A → duration / yellow / classes
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;

    settings = {
      format = "$directory$git_branch$git_status$nix_shell$line_break$character";
      right_format = "$status$cmd_duration";
      add_newline = true;

      character = {
        success_symbol = "[❯](bold #${c.base0B})"; # green
        error_symbol   = "[❯](bold #${c.base08})"; # red
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo  = true;
        style = "bold #${c.base0D}"; # blue
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style  = "bold #${c.base09}"; # orange
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style  = "bold #${c.base08}"; # red
      };

      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = " ";
        style  = "bold #${c.base0E}"; # purple / mauve
      };

      status = {
        disabled = false;
        format = "[$status]($style) ";
        style  = "bold #${c.base08}"; # red
      };

      cmd_duration = {
        min_time = 2000;
        format   = "[$duration]($style)";
        style    = "bold #${c.base0A}"; # yellow
      };
    };
  };
}
