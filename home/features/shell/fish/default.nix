{ pkgs, ... }:

{
  imports = [
    ../shared
  ];

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

    # Plugins (via home-manager)
    plugins = [
      { name = "autopair"; src = pkgs.fishPlugins.autopair-fish.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };

  # Enable shared tools for fish
  programs.direnv.enableFishIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.zoxide.enableFishIntegration = true;
  programs.yazi.enableFishIntegration = true;
}
