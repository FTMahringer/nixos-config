{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    # Faster nix integration, caches devshell environments
    nix-direnv.enable = true;
  };
}
