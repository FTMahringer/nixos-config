{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh = {
    enable = true;

    # --- Fish-like core features ---
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" ];
    };
    historySubstringSearch.enable = true;

    # --- History ---
    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
      expireDuplicatesFirst = true;
    };

    # --- Completion styling & keybindings ---
    initContent = ''
      # Completion styling (Fish-like menu with colors)
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
      zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
      zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' squeeze-slashes true
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$HOME/.zcompcache"

      # Keybindings
      bindkey '^[[H' beginning-of-line        # Home
      bindkey '^[[F' end-of-line              # End
      bindkey '^[[3~' delete-char             # Delete
      bindkey '^[[1;5C' forward-word          # Ctrl+Right
      bindkey '^[[1;5D' backward-word         # Ctrl+Left
      bindkey '^H' backward-kill-word         # Ctrl+Backspace
      bindkey '^[[3;5~' kill-word             # Ctrl+Delete
      bindkey '^[[C' forward-char             # Right arrow (accept autosuggestion)
      bindkey '^[[A' history-substring-search-up    # Up
      bindkey '^[[B' history-substring-search-down  # Down

      # Shell options
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
      setopt CORRECT
      setopt INTERACTIVE_COMMENTS
      setopt NO_BEEP
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS

      function accept-line-or-clear() {
        if [[ -z "$BUFFER" ]]; then
          clear
          zle reset-prompt
        else
          zle accept-line
        fi
      }

      zle -N accept-line-or-clear
      bindkey '^M' accept-line-or-clear
    '';
  };
}
