{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.mangowc;
in
{
  options.ft.programs.mangowc = {
    enable = lib.mkEnableOption "Mango compositor + Wayfire desktop environment (system-level)";
  };

  config = lib.mkIf cfg.enable {
    # wf-config 0.10.0 requires doctest which is missing in nixpkgs unstable.
    # Apply as an overlay so every package in the closure (wayfire, wf-shell,
    # wcm, …) gets the fixed wf-config without separate per-package overrides.
    nixpkgs.overlays = [
      (_final: prev: {
        wf-config = prev.wf-config.overrideAttrs (old: {
          mesonFlags = (old.mesonFlags or []) ++ [ "-Dtests=disabled" ];
        });
        wayfire = prev.wayfire.overrideAttrs (old: {
          mesonFlags = (old.mesonFlags or []) ++ [ "-Dtests=disabled" ];
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      wayfire
      polkit_gnome
      networkmanagerapplet
      brightnessctl
      playerctl
      pamixer
      pavucontrol
      libnotify
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      config.common.default = "*";
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    security.polkit.enable = true;

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --sessions ${pkgs.wayfire}/share/wayland-sessions
        '';
        user = "greeter";
      };
    };

    users.users.fynn.extraGroups = [ "video" "audio" ];
  };
}
