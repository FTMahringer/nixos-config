{ config, pkgs, lib, ... }:

let
  cfg = config.ft.theming;

  # Generate a solid-color default wallpaper when none is provided.
  # Stylix requires an image; this keeps the config buildable out-of-the-box.
  defaultWallpaper = pkgs.runCommand "default-wallpaper.png"
    {
      nativeBuildInputs = [ pkgs.imagemagick ];
    } ''
    magick -size 3840x2160 xc:"#1d2021" png24:$out
  '';
in
{
  options.ft.theming = {
    enable = lib.mkEnableOption "Stylix-based global theming";

    scheme = lib.mkOption {
      type = lib.types.str;
      default = "gruvbox-dark-medium";
      description = ''
        Base16 color scheme name from the base16-schemes package.
        Run: nix build nixpkgs#base16-schemes && ls result/share/themes/
        to list available schemes. Popular choices:
          gruvbox-dark-medium, catppuccin-mocha, tokyo-night-dark,
          nord, dracula, rose-pine, everforest-dark-hard
      '';
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to wallpaper image. Used by Stylix for desktop background
        and as a color generation source (when no explicit scheme is set).
        If null, a solid dark fallback wallpaper is generated.
        Place custom wallpapers in assets/wallpapers/.
      '';
    };

    polarity = lib.mkOption {
      type = lib.types.enum [ "dark" "light" "either" ];
      default = "dark";
      description = "Preferred color scheme polarity.";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml";
      polarity = cfg.polarity;

      image =
        if cfg.wallpaper != null
        then cfg.wallpaper
        else defaultWallpaper;

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          terminal = 13;
          applications = 12;
          desktop = 12;
          popups = 12;
        };
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

    # Install Nerd Fonts system-wide
    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];
  };
}
