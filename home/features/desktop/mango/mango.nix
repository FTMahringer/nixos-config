{ config, lib, pkgs, ... }:

let
  cfg = config.ft.desktop.mango;

  # Prefer ft-nixlaunch if it exists in PATH; fall back to any launcher you might have.
  launcherCmd =
    if pkgs ? ft-nixlaunch then
      "${pkgs.ft-nixlaunch}/bin/ft-nixlaunch"
    else
      "ft-nixlaunch";

  terminalCmd =
    lib.getExe (config.ft.desktop.terminalPackage or pkgs.foot);
in
lib.mkIf cfg.enable {
  # Mango HM module (from mangowm/mango) expects `settings` as a structured attrset,
  # not INI. It will be converted/validated by the upstream module.
  wayland.windowManager.mango = {
    enable = true;

    # Keep this minimal and upstream-compatible.
    #
    # Notes:
    # - `bind` entries are Mango-style (see mangowm/mango nix/hm-modules.nix example).
    # - If some actions differ on your Mango version, you can adjust later; the upstream
    #   module validates the generated config via `mango -c ... -p`.
    settings = {
      # Reasonable defaults; avoid guessing lots of Mango-specific knobs.
      # You can add more once you confirm exact Mango option names from upstream docs.
      animations = 1;

      # Keybinds (keep ft-nixlaunch integration)
      bind = [
        # Reload config
        "SUPER,r,reload_config"

        # Launcher (ft-nixlaunch) — provide multiple ways to open it
        "SUPER,space,spawn,${launcherCmd}"
        "SUPER,d,spawn,${launcherCmd}"

        # Terminal — provide multiple ways to open it (for recovery)
        "SUPER,Return,spawn,${terminalCmd}"
        "SUPER,t,spawn,${terminalCmd}"
        "SUPER,Shift,Return,spawn,${terminalCmd}"

        # Quit mango (if supported by your build; otherwise remove)
        "SUPER,Escape,quit"
      ];
    };

    # Autostart: keep your existing essentials and keep it simple.
    autostart_sh = ''
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      nm-applet --indicator &
      wl-paste --type text  --watch cliphist store &
      wl-paste --type image --watch cliphist store &
      ${config.ft.desktop.bar.package} &
    '';
  };

  # Keep MangoHud config you had (this is separate from Mango WM).
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    fps
    frametime
    cpu_stats
    cpu_temp
    gpu_stats
    gpu_temp
    ram
    vram
    engine_version
    vulkan_driver
    wine
    arch
    no_display
    toggle_hud=Shift_R+F12
    background_alpha=0.5
    font_size=18
    position=top-left
    round_corners=1
    border_radius=5
  '';

  home.packages =
    with pkgs;
    [
      mangohud
    ]
    ++ lib.optionals (pkgs ? ft-nixlaunch) [ pkgs.ft-nixlaunch ];
}
