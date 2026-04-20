{ config, lib, ... }:

let
  cfg = config.ft.homeDir;
in
{
  options.ft.homeDir = {
    enable = lib.mkEnableOption "structured home directory layout";

    nixosConfigPath = lib.mkOption {
      type = lib.types.path;
      default = /etc/nixos;
      description = ''
        Absolute path to the live NixOS configuration directory.
        A symlink at ~/projects/nixos-config will point here.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # ── Projects ─────────────────────────────────────────────────────────────
    home.file."projects/.keep".text = "";
    home.file."projects/nixos-config".source =
      config.lib.file.mkOutOfStoreSymlink cfg.nixosConfigPath;

    home.file."projects/work/.keep".text = "";
    home.file."projects/personal/.keep".text = "";
    home.file."projects/experiments/.keep".text = "";
    home.file."projects/contributions/.keep".text = "";

    # ── Documents ────────────────────────────────────────────────────────────
    home.file."documents/.keep".text = "";
    home.file."documents/notes/.keep".text = "";
    home.file."documents/pdfs/.keep".text = "";
    home.file."documents/receipts/.keep".text = "";
    home.file."documents/templates/.keep".text = "";

    # ── Media ────────────────────────────────────────────────────────────────
    home.file."media/pictures/.keep".text = "";
    home.file."media/pictures/screenshots/.keep".text = "";
    home.file."media/pictures/wallpapers/.keep".text = "";
    home.file."media/videos/.keep".text = "";
    home.file."media/music/.keep".text = "";
    home.file."media/recordings/.keep".text = "";

    # ── Downloads (ensure empty, clean regularly) ────────────────────────────
    home.file."downloads/.keep".text = "";

    # ── Temp (ephemeral — safe to delete anytime) ────────────────────────────
    home.file."temp/.keep".text = "";
    home.file."temp/builds/.keep".text = "";
    home.file."temp/archives/.keep".text = "";

    # ── Sync / Cloud ─────────────────────────────────────────────────────────
    home.file."sync/.keep".text = "";

    # ── Backups ──────────────────────────────────────────────────────────────
    home.file."backups/.keep".text = "";
  };
}
