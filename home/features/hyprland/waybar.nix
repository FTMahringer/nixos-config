{ config, lib, ... }:

lib.mkIf config.ft.desktop.hyprland.enable {

  programs.waybar = {
    enable = true;

    # Waybar is started by Hyprland's systemd graphical-session.target
    # (wayland.windowManager.hyprland.systemd.enable = true triggers it).
    systemd = {
      enable = true;
      targets = [ "hyprland-session.target" ];
    };

    settings = [
      {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "cpu"
          "memory"
          "backlight"
          "battery"
          "pulseaudio"
          "network"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰎤";
            "2" = "󰎧";
            "3" = "󰎪";
            "4" = "󰎭";
            "5" = "󰎱";
            active = "󰮯";
            default = "○";
            urgent = "●";
          };
          persistent-workspaces = {
            "*" = 5; # always show 5 workspace buttons
          };
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        "hyprland/window" = {
          max-length = 48;
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "󰈹 $1";
            "(.*) - fish" = " $1";
            "(.*) - zsh" = " $1";
          };
        };

        clock = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A %d. %B %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
          };
        };

        cpu = {
          format = "  {usage}%";
          interval = 5;
          tooltip = false;
        };

        memory = {
          format = "  {percentage}%";
          interval = 10;
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
        };

        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰁹 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{timeTo} — {power:.1f} W";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟  muted";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        network = {
          format-wifi = "󰤨  {essid}";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰤭  offline";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n↑ {bandwidthUpBits}  ↓ {bandwidthDownBits}";
          tooltip-format-ethernet = "{ifname} — {ipaddr}";
          on-click = "nm-connection-editor";
        };

        tray = {
          spacing = 10;
          icon-size = 16;
        };
      }
    ];

    # Stylix generates the base16 color palette as @define-color variables and
    # sets the bar's background/foreground.  We only add structural CSS on top.
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        border-bottom: 2px solid @base0D;
      }

      /* Workspace buttons */
      #workspaces button {
        padding: 0 8px;
        border-radius: 6px;
        transition: all 0.2s ease;
      }
      #workspaces button.active {
        border-radius: 6px;
        font-weight: bold;
      }
      #workspaces button.urgent {
        border-radius: 6px;
      }

      /* Module pill padding */
      #clock,
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #backlight,
      #tray {
        padding: 0 10px;
        margin: 4px 2px;
        border-radius: 6px;
      }

      /* Battery state colors */
      #battery.warning:not(.charging) {
        color: @base09;
      }
      #battery.critical:not(.charging) {
        color: @base08;
        animation: blink 0.5s linear infinite;
      }
      #battery.charging {
        color: @base0B;
      }

      @keyframes blink {
        to { opacity: 0.5; }
      }
    '';
  };
}
