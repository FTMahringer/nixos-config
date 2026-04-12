{ config, lib, pkgs, inputs, ... }:

let
  # nixpalette → Stylix base16 colors
  c = config.lib.stylix.colors;
in
{
  # General development tools and environment
  home.packages = with pkgs; [
    # --- Languages & Runtimes ---
    nodejs           # Node.js (includes npm)
    nodePackages.pnpm # Fast, disk space efficient package manager
    nodePackages.yarn # Alternative package manager
    bun              # Fast JavaScript runtime and package manager

    # --- Container & Virtualization ---
    docker           # Container platform
    docker-compose   # Multi-container Docker applications
    lazydocker       # Terminal UI for Docker (like lazygit for docker)

    # --- API Development & Testing ---
    postman          # API testing tool
    httpie           # Command-line HTTP client (user-friendly curl alternative)
    xh               # Fast HTTP client (Rust, like httpie)

    # --- Kubernetes ---
    kubectl          # Kubernetes CLI
    k9s              # Kubernetes TUI

    # --- Build Tools ---
    gnumake          # Make build tool
    cmake            # Cross-platform build system
    ninja            # Fast build system

    # --- Version Control ---
    git-lfs          # Git Large File Storage
    delta            # Syntax-highlighting pager for git
    tig              # Text-mode interface for git

    # --- Utilities ---
    tree             # Directory tree viewer
    fd               # Fast find alternative
    ripgrep          # Fast grep alternative
    sd               # Find & replace (sed alternative)
    hyperfine        # Command-line benchmarking
    tokei            # Count lines of code

    # --- File Transfer ---
    rsync            # Fast file sync

    # --- Process & System Monitoring ---
    htop             # Process viewer
    iotop            # IO monitoring
    nethogs          # Network monitoring

    # --- Network Tools ---
    nmap             # Network scanner
    netcat           # Network utility
    socat            # Multipurpose relay

    # --- Misc Dev Tools ---
    shellcheck       # Shell script linter
    shfmt            # Shell script formatter
    hadolint         # Dockerfile linter
    tldr             # Simplified man pages
    cheat            # Interactive cheatsheets
  ];

  # --- Git Delta Configuration with nixpalette colors ---
  programs.git.delta = {
    enable = true;
    options = {
      features = "line-numbers decorations";
      syntax-theme = "base16";
      #line-numbers = true;
      # Use nixpalette colors
      plus-color = "#${c.base0B}";
      plus-emph-color = "#${c.base0B}";
      minus-color = "#${c.base08}";
      minus-emph-color = "#${c.base08}";
      decorations = {
        commit-decoration-style = "bold #${c.base0A} box ul";
        file-decoration-style = "none";
        file-style = "bold #${c.base0A} ul";
        hunk-header-decoration-style = "#${c.base0D} box ul";
        hunk-header-file-style = "#${c.base0D}";
        hunk-header-line-number-style = "#${c.base03}";
        hunk-header-style = "file line-number";
      };
      line-numbers = {
        left-format = "{nm:>4} │";
        right-format = "{np:>4} │";
        left-style = "#${c.base03}";
        right-style = "#${c.base03}";
        minus-style = "#${c.base08}";
        minus-emph-style = "bold #${c.base08}";
        plus-style = "#${c.base0B}";
        plus-emph-style = "bold #${c.base0B}";
      };
    };
  };

  # --- Node.js/npm Configuration ---
  home.file.".npmrc".text = ''
    # npm configuration
    prefix=''${HOME}/.npm-packages
    cache=''${HOME}/.npm-cache
  '';

  # Add npm global packages to PATH
  home.sessionPath = [ "$HOME/.npm-packages/bin" ];

  # --- Environment Variables ---
  home.sessionVariables = {
    # Node.js
    NODE_OPTIONS = "--max-old-space-size=4096";

    # Docker
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";

    # Editor for git, etc.
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # --- Shell Aliases for Development ---
  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    # Docker
    d = "docker";
    dc = "docker-compose";
    ld = "lazydocker";

    # Node.js
    n = "node";
    ni = "npm install";
    nid = "npm install --save-dev";
    nr = "npm run";
    ns = "npm start";
    nt = "npm test";

    # pnpm shortcuts
    pn = "pnpm";
    pni = "pnpm install";
    pnd = "pnpm add --save-dev";
    pnr = "pnpm run";

    # Git with delta
    gd = "git diff";
    gds = "git diff --staged";

    # HTTP requests
    http = "httpie";

    # Kubernetes
    k = "kubectl";
    k9 = "k9s";
  };

  # --- fzf Configuration with nixpalette colors ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always {}'"
    ];
    # Use nixpalette colors
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    colors = {
      bg = "#${c.base00}";
      "bg+" = "#${c.base01}";
      fg = "#${c.base05}";
      "fg+" = "#${c.base06}";
      hl = "#${c.base0D}";
      "hl+" = "#${c.base0C}";
      info = "#${c.base0A}";
      prompt = "#${c.base0D}";
      pointer = "#${c.base0C}";
      marker = "#${c.base0B}";
      spinner = "#${c.base0E}";
      header = "#${c.base04}";
    };
  };

  # --- bat Configuration (for fzf previews) with nixpalette ---
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
      style = "numbers,changes,header";
    };
  };

  # --- lazygit Configuration (additional to daily-tools.nix) ---
  # This extends the lazygit config with more nixpalette integration
  programs.lazygit.settings.gui.theme = {
    # Additional theme overrides using nixpalette
    searchingActiveBorderColor = [ "#${c.base0A}" "bold" ];  # Yellow for search
    authorColors = {
      "*" = "#${c.base0D}";  # Blue for all authors
    };
  };

  # --- k9s Configuration with nixpalette colors ---
  xdg.configFile."k9s/config.yml".text = ''
    k9s:
      ui:
        skin: base16
        enableMouse: true
        headless: false
        logoless: false
        crumbsless: false
        noIcons: false
        reactive: false
      '';

  # k9s base16 skin using nixpalette colors
  xdg.configFile."k9s/skins/base16.yml".text = ''
    k9s:
      body:
        fgColor: "#${c.base05}"
        bgColor: "#${c.base00}"
        logoColor: "#${c.base0D}"
      prompt:
        fgColor: "#${c.base05}"
        bgColor: "#${c.base00}"
        suggestColor: "#${c.base0D}"
      info:
        fgColor: "#${c.base0A}"
        sectionColor: "#${c.base05}"
      dialog:
        fgColor: "#${c.base05}"
        bgColor: "#${c.base01}"
        buttonFgColor: "#${c.base05}"
        buttonBgColor: "#${c.base02}"
        buttonFocusFgColor: "#${c.base00}"
        buttonFocusBgColor: "#${c.base0D}"
        labelFgColor: "#${c.base0C}"
        fieldFgColor: "#${c.base05}"
      frame:
        border:
          fgColor: "#${c.base02}"
          focusColor: "#${c.base0D}"
        menu:
          fgColor: "#${c.base05}"
          keyColor: "#${c.base0D}"
          numKeyColor: "#${c.base0A}"
        crumbs:
          fgColor: "#${c.base00}"
          bgColor: "#${c.base0D}"
          activeColor: "#${c.base0A}"
        status:
          newColor: "#${c.base0B}"
          modifyColor: "#${c.base0D}"
          addColor: "#${c.base0B}"
          errorColor: "#${c.base08}"
          highlightcolor: "#${c.base0A}"
          killColor: "#${c.base08}"
          completedColor: "#${c.base03}"
        title:
          fgColor: "#${c.base0D}"
          highlightColor: "#${c.base0A}"
          counterColor: "#${c.base0C}"
          filterColor: "#${c.base0E}"
      views:
        charts:
          bgColor: "#${c.base00}"
          defaultDialColors:
            - "#${c.base0D}"
            - "#${c.base08}"
          defaultChartColors:
            - "#${c.base0D}"
            - "#${c.base08}"
        table:
          fgColor: "#${c.base05}"
          bgColor: "#${c.base00}"
          header:
            fgColor: "#${c.base05}"
            bgColor: "#${c.base01}"
            sorterColor: "#${c.base0C}"
        xray:
          fgColor: "#${c.base05}"
          bgColor: "#${c.base00}"
          cursorColor: "#${c.base01}"
          graphicColor: "#${c.base0D}"
          selectColor: "#${c.base02}"
        yaml:
          keyColor: "#${c.base0D}"
          colonColor: "#${c.base03}"
          valueColor: "#${c.base05}"
        logs:
          fgColor: "#${c.base05}"
          bgColor: "#${c.base00}"
          indicator:
            fgColor: "#${c.base0D}"
            bgColor: "#${c.base00}"
      help:
        fgColor: "#${c.base05}"
        bgColor: "#${c.base00}"
        indicator:
          fgColor: "#${c.base0D}"
          bgColor: "#${c.base00}"
  '';

  # --- lazydocker Configuration with nixpalette colors ---
  xdg.configFile."lazydocker/config.yml".text = ''
    gui:
      scrollHeight: 2
      scrollPastBottom: true
      mouseEvents: true
      ignoreMouseEvents: false
      theme:
        activeBorderColor:
          - "#${c.base0D}"
          - "bold"
        inactiveBorderColor:
          - "#${c.base03}"
        optionsTextColor:
          - "#${c.base0D}"
        selectedLineBgColor:
          - "#${c.base02}"
        selectedRangeBgColor:
          - "#${c.base02}"
        cherryPickedCommitBgColor:
          - "#${c.base02}"
        cherryPickedCommitFgColor:
          - "#${c.base0D}"
        unstagedChangesColor:
          - "#${c.base08}"
        defaultFgColor:
          - "#${c.base05}"
    '';

  # --- htop Configuration with nixpalette colors ---
  programs.htop = {
    enable = true;
    settings = {
      # Use terminal colors (which are set by nixpalette/stylix)
      color_scheme = 0;  # 0 = Default (uses terminal colors)
      tree_view = true;
      show_cpu_frequency = true;
      show_cpu_usage = true;
      show_program_path = false;
    };
  };

  # --- fnm (Fast Node Manager) ---
  # fnm is installed as a package, add shell integration manually
  programs.zsh.initContent = lib.mkIf config.programs.zsh.enable (lib.mkAfter ''
    # fnm - Fast Node Manager
    if command -v fnm &> /dev/null; then
      eval "$(fnm env --use-on-cd)"
    fi
  '');
}
