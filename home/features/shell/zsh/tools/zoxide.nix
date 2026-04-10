{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    # Replace cd with smart zoxide version (cd/cdi instead of z/zi)
    options = [ "--cmd cd" ];
  };
}
