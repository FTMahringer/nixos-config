{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.mangowc;

  # wf-config 0.10.0 requires doctest which is missing in nixpkgs unstable.
  # Pass -Dtests=disabled so meson doesn't look for it during configure.
  wf-config-fixed = pkgs.wf-config.overrideAttrs (old: {
    mesonFlags = (old.mesonFlags or []) ++ [ "-Dtests=disabled" ];
  });
  wayfire-fixed   = pkgs.wayfire.override { wf-config = wf-config-fixed; };
in
{
  options.ft.programs.mangowc = {
    enable = lib.mkEnableOption "Mango compositor + Wayfire desktop environment (system-level)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wayfire-fixed
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
            --sessions ${wayfire-fixed}/share/wayland-sessions
        '';
        user = "greeter";
      };
    };

    users.users.fynn.extraGroups = [ "video" "audio" ];
  };
}
