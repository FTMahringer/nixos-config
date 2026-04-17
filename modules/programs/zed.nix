{ config, lib, pkgs, ... }:

let
  cfg = config.ft.programs.zed;

  # Wrap zed-editor so it always has nodejs in PATH for ACP registry agents
  zed-wrapped = pkgs.symlinkJoin {
    name = "zed-editor-wrapped";
    paths = [ pkgs.zed-editor ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zed \
        --prefix PATH : "${pkgs.nodejs}/bin:/run/current-system/sw/bin"
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
    # Replace the default zed-editor with our wrapped version that has
    # nodejs in PATH. This ensures ACP registry agents (Claude, Codex,
    # GitHub Copilot) can install their npm adapters internally.
    nixpkgs.config.packageOverrides = pkgs: {
      zed-editor = zed-wrapped;
    };
  };
}
