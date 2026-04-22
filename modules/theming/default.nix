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

  config = lib.mkIf cfg.enable {
    # NixOS specialisations for boot-menu theme switching
    # Each specialisation overrides the home-manager ft-nixpalette theme
    specialisation = lib.mapAttrs
      (name: theme: {
        configuration = {
          home-manager.users.fynn.ft-nixpalette.theme = lib.mkForce theme;
        };
      })
      cfg.specialisations;

    # Nerd Font available system-wide (e.g. for rofi, waybar, etc.)
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
}
