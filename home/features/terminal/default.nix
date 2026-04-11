{ config, lib, ... }:

{
  imports = [
    ./kitty.nix
    ./wezterm.nix
  ];

  options.ft.terminal = {
    kitty.enable = lib.mkEnableOption "Kitty terminal emulator";
    wezterm.enable = lib.mkEnableOption "WezTerm terminal emulator";

    # --- Shared defaults (non-theme; Stylix handles colors/fonts/opacity) ---

    defaults = {
      padding = lib.mkOption {
        type = lib.types.int;
        default = 12;
        description = "Window padding in pixels.";
      };

      scrollbackLines = lib.mkOption {
        type = lib.types.int;
        default = 10000;
        description = "Number of scrollback lines to keep.";
      };

      cursorStyle = lib.mkOption {
        type = lib.types.enum [ "block" "beam" "underline" ];
        default = "beam";
        description = "Cursor shape. Stylix handles cursor color.";
      };

      cursorBlink = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the cursor should blink.";
      };

      confirmClose = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Prompt before closing terminal with running processes.";
      };
    };
  };
}
