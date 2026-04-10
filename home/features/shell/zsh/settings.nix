{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History settings
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    # Oh-my-zsh configuration
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "history" ];
    };

    # Aliases
    shellAliases = {
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
      update = "nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#laptop";
    };

    # Custom init extra (runs after oh-my-zsh)
    # Note: nix-your-shell is handled in system module
    initExtra = ''
      # Custom keybindings
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^[[3~" delete-char
    '';
  };
}
