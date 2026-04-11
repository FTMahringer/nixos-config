{ config, lib, ... }:

# We manage hyprlock theming ourselves (stylix.targets.hyprlock disabled in
# theming.nix) so we can choose the layout and reference colors directly via
# config.lib.stylix.colors.
lib.mkIf config.ft.desktop.hyprland.enable {

  programs.hyprlock = {
    enable = true;

    settings =
      let
        c = config.lib.stylix.colors;
      in
      {
        general = {
          disable_loading_bar = false;
          hide_cursor = true;
          grace = 0;
          no_fade_in = false;
        };

        background = [
          {
            monitor = "";
            path = "screenshot"; # blur a screenshot of the desktop
            blur_passes = 3;
            blur_size = 7;
            noise = 0.0117;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];

        # Clock label
        label = [
          {
            monitor = "";
            text = "$TIME";
            color = "rgba(${c.base05}ff)";
            font_size = 72;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 250";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          {
            monitor = "";
            text = "cmd[update:86400000] date +\"%A, %d. %B\"";
            color = "rgba(${c.base04}ff)";
            font_size = 20;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 155";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "280, 50";
            outline_thickness = 2;
            dots_size = 0.33;
            dots_spacing = 0.15;
            position = "0, -80";
            halign = "center";
            valign = "center";
            placeholder_text = "<i>Password…</i>";
            hide_input = false;
            rounding = 8;

            # Colors from active nixpalette theme
            outer_color = "rgb(${c.base0D})";
            inner_color = "rgb(${c.base00})";
            font_color = "rgb(${c.base05})";
            check_color = "rgb(${c.base0B})";
            fail_color = "rgb(${c.base08})";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";

            capslock_color = "rgb(${c.base0A})";
          }
        ];
      };
  };
}
