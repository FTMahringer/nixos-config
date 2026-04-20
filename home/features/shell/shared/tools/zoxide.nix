{
  programs.zoxide = {
    enable = true;
    # Replace cd with smart zoxide version (cd/cdi instead of z/zi)
    options = [ "--cmd cd" ];
  };
}
