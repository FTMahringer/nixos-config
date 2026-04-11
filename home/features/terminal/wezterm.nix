{ config, lib, ... }:

let
  cfg = config.ft.terminal;
  d = cfg.defaults;

  # Map shared cursor options to WezTerm Lua enum names
  cursorStyleMap = {
    "block" = "SteadyBlock";
    "beam" = "SteadyBar";
    "underline" = "SteadyUnderline";
  };
  blinkingCursorStyleMap = {
    "block" = "BlinkingBlock";
    "beam" = "BlinkingBar";
    "underline" = "BlinkingUnderline";
  };

  weztermCursorStyle =
    if d.cursorBlink
    then blinkingCursorStyleMap.${d.cursorStyle}
    else cursorStyleMap.${d.cursorStyle};

  closeConfirm =
    if d.confirmClose then ''"AlwaysPrompt"'' else ''"NeverPrompt"'';
in
lib.mkIf cfg.wezterm.enable {
  programs.wezterm = {
    enable = true;

    # Stylix auto-generates the full wezterm.lua and wraps extraConfig
    # in a function. We must RETURN a table — not use config_builder().
    # Stylix handles: color_scheme, font, font_size, window_background_opacity,
    #                 window_frame colors, tab bar colors, command palette colors.

    extraConfig = ''
      return {
        -- Window
        window_padding = {
          left = ${toString d.padding},
          right = ${toString d.padding},
          top = ${toString d.padding},
          bottom = ${toString d.padding},
        },
        window_decorations = "TITLE | RESIZE",
        window_close_confirmation = ${closeConfirm},

        -- Cursor (shape + blink; Stylix handles color)
        default_cursor_style = "${weztermCursorStyle}",
        cursor_blink_rate = ${if d.cursorBlink then "500" else "0"},
        cursor_blink_ease_in = "Constant",
        cursor_blink_ease_out = "Constant",

        -- Scrollback
        scrollback_lines = ${toString d.scrollbackLines},

        -- Rendering
        front_end = "WebGpu",
        webgpu_power_preference = "HighPerformance",
        max_fps = 120,
        animation_fps = 60,

        -- Bell
        audible_bell = "Disabled",

        -- Tab bar
        use_fancy_tab_bar = true,
        tab_bar_at_bottom = true,
        hide_tab_bar_if_only_one_tab = true,

        -- Misc
        automatically_reload_config = true,
        check_for_updates = false,
      }
    '';
  };
}
