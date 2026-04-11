{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.hyprland;
in
{
  options.ft.programs.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor (system-level)";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # xdg-desktop-portal-hyprland is added automatically by programs.hyprland.
    # We add xdg-desktop-portal-gtk for GTK file pickers and fallback dialogs.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    # Audio via PipeWire (replaces PulseAudio)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    # Polkit — required for privilege escalation in Wayland sessions
    security.polkit.enable = true;

    # Login manager: greetd + tuigreet (minimal TUI greeter)
    # Use --sessions to discover the Hyprland .desktop session file that
    # programs.hyprland places under /run/current-system/sw/share/wayland-sessions.
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --remember-session \
            --sessions /run/current-system/sw/share/wayland-sessions
        '';
        user = "greeter";
      };
    };

    environment.systemPackages = with pkgs; [
      polkit_gnome # Polkit authentication agent (launched via Hyprland exec-once)
      networkmanagerapplet # nm-applet system-tray icon
      brightnessctl # Backlight control (needs video group)
      playerctl # Media key control
      pamixer # PipeWire CLI volume control
      pavucontrol # Volume control GUI
      libnotify # notify-send CLI
      nautilus # File manager ($fileManager in Hyprland)
    ];

    # Backlight access without sudo, audio group for PipeWire
    users.users.fynn.extraGroups = [ "video" "audio" ];
  };
}
