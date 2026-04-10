{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.ft.system.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.ft.system.impermanence = {
    enable = lib.mkEnableOption "Impermanence - ephemeral root filesystem";

    persistDir = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Directory where persistent data is stored.";
    };

    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional directories to persist.";
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional files to persist.";
    };
  };

  config = lib.mkIf cfg.enable {
    # The persistent storage directory
    environment.persistence.${cfg.persistDir} = {
      enable = true;
      hideMounts = true;

      # System directories to persist
      directories = [
        "/var/log"             # Logs
        "/var/lib/nixos"       # NixOS state (UID/GID mappings)
        "/var/lib/systemd"     # Systemd state
        "/var/lib/sops"        # SOPS age keys
      ] ++ cfg.directories;

      # System files to persist
      files = [
        "/etc/machine-id"      # Systemd machine ID
      ] ++ cfg.files;
    };

    # NOTE: You must define the fileSystem for /persist in your host config!
    # Example:
    # fileSystems."/persist" = {
    #   device = "/dev/disk/by-label/persist";
    #   fsType = "ext4";
    #   neededForBoot = true;
    # };
  };
}
