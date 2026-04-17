{ config, lib, pkgs, ... }:

let
  cfg = config.ft.programs.zed;

  # Wrapper for zed that ensures nodejs is in PATH.
  # ACP registry agents (Claude, Codex, GitHub Copilot) spawn npm/npx
  # internally to install their adapters. Without node in PATH, this fails.
  zed-with-node = pkgs.writeShellApplication {
    name = "zed";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      exec ${pkgs.zed-editor}/bin/zed "$@"
    '';
  };
in
{
  options.ft.programs.zed = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zed editor with ACP (Agent Client Protocol) support.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Add our wrapper to the system packages. It shadows the original zed-editor
    # binary because writeShellApplication produces a "zed" binary in its bin/.
    environment.systemPackages = [ zed-with-node ];
  };
}
