{ config, lib, pkgs, ... }:

let
  cfg = config.ft.programs.zed;
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
    # Zed's ACP registry agents (Claude, Codex, Gemini, GitHub Copilot) spawn
    # npm/npx internally to install their adapters. On NixOS, GUI apps launched
    # from .desktop files don't inherit the user's shell PATH, so Zed can't find
    # node/npm. We fix this by overriding the desktop entry to prepend the
    # system profile bin directory to PATH.
    xdg.desktopEntries.zed = {
      name = "Zed";
      comment = "A high-performance, multiplayer code editor";
      exec = "env PATH=${pkgs.nodejs}/bin:/run/current-system/sw/bin:\$PATH zed %F";
      terminal = false;
      type = "Application";
      icon = "zed";
      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      mimeType = [
        "text/plain"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-java"
        "text/x-dsrc"
        "text/x-pascal"
        "text/x-perl"
        "text/x-python"
        "text/x-ruby"
        "text/x-shellscript"
        "text/x-sql"
        "text/xml"
        "text/x-makefile"
        "text/x-cmake"
        "text/x-markdown"
        "text/x-yaml"
        "text/x-json"
        "text/x-css"
        "text/x-javascript"
        "text/x-typescript"
        "text/x-html"
        "application/x-php"
        "application/x-wine-extension-ini"
        "application/x-wine-extension-inf"
      ];
      startupNotify = true;
      settings = {
        StartupWMClass = "dev.zed.Zed";
      };
    };
  };
}
