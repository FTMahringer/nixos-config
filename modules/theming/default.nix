{ config, pkgs, lib, ... }:

let
  cfg = config.ft.theming;
in
{
  options.ft.theming = {
    enable = lib.mkEnableOption "ft-nixpalette-based global theming";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "builtin:base/catppuccin-mocha";
      description = ''
        ft-nixpalette theme ID to activate.  Format:
          "builtin:base/<name>"    — shipped with ft-nixpalette
          "builtin:derived/<name>" — derived builtin
          "user:base/<name>"       — your own theme in assets/themes/base/
          "user:derived/<name>"    — your own derived theme

        Built-in themes: catppuccin-mocha, nord, gruvbox, dracula
      '';
    };

    userThemeDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Absolute path to the directory containing your user themes.
        Must have a base/ and/or derived/ subdirectory.
      '';
    };

    specialisations = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Map of specialisation name → theme ID.
        Each entry generates a NixOS specialisation reachable from the
        boot menu without a full rebuild.
      '';
    };

    preloadThemes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional theme IDs to bake into /etc/ft-nixpalette/themes.json at
        build time for live switching without a NixOS rebuild.
      '';
    };
  };

  # Map ft.theming.* options to ft-nixpalette.* options
  config = lib.mkIf cfg.enable {
    ft-nixpalette = {
      enable = true;
      theme = cfg.theme;
      userThemeDir = cfg.userThemeDir;
      specialisations = cfg.specialisations;
      preloadThemes = cfg.preloadThemes;

      # Override Stylix defaults so every theme gets:
      #   • JetBrainsMono Nerd Font for terminal icon support
      #   • Bibata cursor
      #   • Slight terminal transparency
      stylixOverrides = {
        fonts.monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };

        opacity = {
          terminal = 0.95;
          applications = 1.0;
          desktop = 1.0;
          popups = 1.0;
        };
      };
    };

    # Nerd Font available system-wide (e.g. for rofi, waybar, etc.)
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
}
