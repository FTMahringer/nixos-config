{
  programs.direnv = {
    enable = true;
    # Faster nix integration, caches devshell environments
    nix-direnv.enable = true;
  };
}
