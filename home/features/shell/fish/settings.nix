{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # Interactive shell initialization
    interactiveShellInit = ''
      # nix-your-shell integration
      if command -q nix-your-shell
        nix-your-shell fish | source
      end

      # Disable greeting
      set -g fish_greeting
    '';

    # Shell aliases
    shellAliases = {
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
      update = "nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#laptop";
    };

    # Shell functions
    functions = {
      # Custom fish prompt (optional, can also use starship or other)
      fish_prompt = {
        body = ''
          set -l last_status $status
          set -l prompt_char "❯"

          # Show current directory
          set_color blue
          echo -n (prompt_pwd)
          set_color normal

          # Git status (if in git repo)
          if git rev-parse --git-dir > /dev/null 2>&1
            set -l git_branch (git branch --show-current 2>/dev/null)
            set_color yellow
            echo -n " ($git_branch)"
            set_color normal
          end

          # New line and prompt char
          echo
          if test $last_status -eq 0
            set_color green
          else
            set_color red
          end
          echo -n "$prompt_char "
          set_color normal
        '';
      };
    };

    # Plugins (via home-manager)
    plugins = [
      # Fish will use these plugins
      { name = "autopair"; src = pkgs.fishPlugins.autopair-fish.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };
}
