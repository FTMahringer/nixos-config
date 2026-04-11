{ config, pkgs, lib, ... }:

let
  cfg = config.ft.theming;
in
{
  options.ft.theming = {
    enable = lib.mkEnableOption "nixpalette-based global theming";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "builtin:base/catppuccin-mocha";
      description = ''
        nixpalette theme ID to activate.  Format:
          "builtin:base/<name>"    — shipped with nixpalette
          "builtin:derived/<name>" — derived builtin
          "user:base/<name>"       — your own theme in assets/themes/base/
          "user:derived/<name>"    — your own derived theme

        Built-in themes: catppuccin-mocha, nord
        Run `nix eval .#nixosConfigurations.laptop.config.nixpalette.availableThemes`
        to list everything nixpalette can see.
      '';
    };

    userThemeDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Absolute path to the directory containing your user themes.
        Must have a base/ and/or derived/ subdirectory.
        Example: set to `../../assets/themes` relative to configuration.nix,
        or use an absolute path like /etc/nixos/assets/themes.
        When null, only built-in themes are available.
      '';
    };

    specialisations = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Map of specialisation name → theme ID.
        Each entry generates a NixOS specialisation reachable from the
        boot menu without a full rebuild.  Example:
          specialisations = {
            nord    = "builtin:base/nord";
            gruvbox = "user:base/gruvbox";
          };
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    nixpalette = {
      enable = true;
      theme = cfg.theme;
      userThemeDir = cfg.userThemeDir;
      specialisations = cfg.specialisations;

      # Override Stylix defaults so every theme (builtin or user) gets:
      #   • JetBrainsMono Nerd Font for terminal icon support
      #   • Bibata cursor
      #   • Slight terminal transparency
      # These sit above the per-theme mkDefault values, so they win
      # regardless of what the theme.nix specifies for fonts.monospace.
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
