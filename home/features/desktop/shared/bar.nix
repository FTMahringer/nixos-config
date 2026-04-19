{ config, lib, pkgs, ... }:

let
  cfg = config.ft.desktop.bar;
in
{
  options.ft.desktop.bar = {
    enable = lib.mkEnableOption "status bar (home-manager)" // { default = true; };

    package = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.eww}/bin/eww open bar";
      description = ''
        Command to start the status bar.
        Default uses eww (ElKowar's Wacky Widgets).
      '';
    };

    backend = lib.mkOption {
      type = lib.types.enum [ "eww" "waybar" "none" ];
      default = "eww";
      description = ''
        Bar backend to use:
          "eww"    — ElKowar's Wacky Widgets (modern, highly customizable)
          "waybar" — Classic Waybar status bar
          "none"   — No bar
      '';
    };
  };

  config = lib.mkIf (config.ft.desktop.enable && cfg.enable) (lib.mkMerge [
    # ── eww backend ───────────────────────────────────────────────────────────
    (lib.mkIf (cfg.backend == "eww") {
      programs.eww = {
        enable = true;
        package = pkgs.eww;
        configDir = null; # we use xdg.configFile below
      };

      xdg.configFile."eww/eww.yuck".text = ''
        (defwidget bar []
          (box :class "bar" :orientation "h" :space-evenly true
            (workspaces)
            (window-title)
            (system-tray)))

        (defwidget workspaces []
          (box :class "workspaces"
            (label :text "󰎤")
            (label :text "󰎧")
            (label :text "󰎪")
            (label :text "󰎭")
            (label :text "󰎱")))

        (defwidget window-title []
          (box :class "window-title"
            (label :text "${"{"}window-title${"}"}")))

        (defwidget system-tray []
          (box :class "system-tray" :space-evenly false
            (metric :label "󰍛" :value "${"{"}EWW_RAM.used_perc${"}"}")
            (metric :label "󰁹" :value "${"{"}EWW_BATTERY.BAT0.capacity${"}"}")
            (label :text "${"{"}time${"}"}")))

        (defwidget metric [label value]
          (box :orientation "h" :class "metric" :space-evenly false
            (label :text label)
            (label :text "${"{"}value${"}"}%")))

        (defwindow bar
          :monitor 0
          :geometry (geometry :x "0%"
                              :y "0%"
                              :width "100%"
                              :height "30px"
                              :anchor "top center")
          :stacking "fg"
          :exclusive true
          :focusable false
          (bar))

        (defpoll time :interval "1s"
          "date '+%H:%M'")

        (deflisten window-title :initial "..."
          "${pkgs.bash}/bin/bash -c 'while true; do ${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r .title 2>/dev/null || echo \"\"; sleep 0.5; done'")
      '';

      xdg.configFile."eww/eww.scss".text = ''
        * {
          all: unset;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
        }

        .bar {
          background-color: rgba(0, 0, 0, 0.7);
          color: #ffffff;
          padding: 0 12px;
        }

        .workspaces {
          padding: 0 8px;
          label {
            padding: 0 6px;
            margin: 0 2px;
            border-radius: 4px;
            &:hover {
              background-color: rgba(255, 255, 255, 0.1);
            }
          }
        }

        .window-title {
          color: #aaaaaa;
          font-size: 12px;
        }

        .system-tray {
          padding: 0 8px;
          label {
            padding: 0 8px;
          }
        }

        .metric {
          label {
            padding: 0 4px;
          }
        }
      '';
    })

    # ── waybar backend (kept for backwards compat) ────────────────────────────
    (lib.mkIf (cfg.backend == "waybar") {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          targets = [ "hyprland-session.target" ];
        };

        settings = [{
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
              "*" = 5;
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
        }];

        style = ''
          * {
            font-family: "JetBrainsMono Nerd Font";
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            border-bottom: 2px solid @base0D;
          }

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
    })
  ]);
}
