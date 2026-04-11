{ config, lib, ... }:

let
  cfg = config.ft.terminal;
  d = cfg.defaults;
in
lib.mkIf cfg.kitty.enable {
  programs.kitty = {
    enable = true;

    # Stylix auto-sets: font, font_size, background_opacity, colors (via extraConfig include).
    # Everything below is non-theme configuration.

    settings = {
      # --- Window ---
      window_padding_width = d.padding;
      placement_strategy = "center";
      hide_window_decorations = false;
      confirm_os_window_close =
        if d.confirmClose then 1 else -1;

      # --- Cursor (shape + blink; Stylix handles color) ---
      cursor_shape = d.cursorStyle;
      cursor_blink_interval =
        if d.cursorBlink then "0.5" else "0";
      cursor_stop_blinking_after = 15;

      # --- Scrollback ---
      scrollback_lines = d.scrollbackLines;
      scrollback_pager_history_size = 4;

      # --- Mouse ---
      mouse_hide_wait = "3.0";
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";

      # --- Performance ---
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # --- Bell ---
      enable_audio_bell = false;
      visual_bell_duration = "0.0";

      # --- URLs ---
      detect_urls = true;
      url_style = "curly";

      # --- Tab bar ---
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_edge = "bottom";

      # --- Shell integration ---
      shell_integration = "enabled";
    };
  };
}
