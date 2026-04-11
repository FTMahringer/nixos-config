{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.ft.programs.hyprland;
  hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandPortal = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in
{
  options.ft.programs.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor (system-level)";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandPkg;
      portalPackage = hyprlandPortal;
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

    # Override hyprlock PAM service — remove try_first_pass so pam_unix waits
    # for actual user input instead of immediately trying a null token and
    # triggering pam_deny → "authentication failed (1)" on startup.
    security.pam.services.hyprlock.text = lib.mkForce ''
      auth      sufficient  pam_unix.so likeauth nullok nodelay
      auth      required    pam_deny.so

      account   required    pam_unix.so

      password  sufficient  pam_unix.so nullok yescrypt

      session   required    pam_env.so readenv=0
      session   required    pam_unix.so
      session   required    pam_limits.so
    '';

    # Login manager: greetd + tuigreet (minimal TUI greeter)
    # Session file comes from the flake's Hyprland package directly.
    services.greetd = {
      enable = true;
      #vt = 1;
      settings.default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --sessions ${hyprlandPkg}/share/wayland-sessions
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
