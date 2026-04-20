{ config, ... }:

let
  # nixpalette → Stylix base16 colors — same palette as starship.nix.
  c = config.lib.stylix.colors;
in
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
      # Colors are managed by the Stylix zsh-syntax-highlighting target
      # (auto-enabled via nixpalette → Stylix).
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
      # Completion colors — use nixpalette base16 hex values so they match
      # the active theme regardless of what the terminal calls "yellow" etc.
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*:descriptions' format '%F{#${c.base0A}}-- %d --%f'  # yellow (base0A)
      zstyle ':completion:*:messages'     format '%F{#${c.base0E}}-- %d --%f'  # purple (base0E)
      zstyle ':completion:*:warnings'     format '%F{#${c.base08}}-- no matches --%f' # red (base08)
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

  # Enable shared tools for zsh
  programs.direnv.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
  programs.yazi.enableZshIntegration = true;
}
