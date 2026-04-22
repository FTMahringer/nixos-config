{ config, lib, pkgs, ... }:

let
  cfg = config.ft.system.github-token;
in
{
  options.ft.system.github-token = {
    enable = lib.mkEnableOption "GitHub access token for Nix flake updates";

    secretPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/secrets/api_tokens_github";
      description = ''
        Path to the file containing the GitHub Personal Access Token.
        Set up via sops-nix (ft.security.sops).
        Default path follows sops-nix convention for nested keys (dots become underscores).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Write the GitHub token into /etc/nix/nix.conf via activation script.
    # This runs at boot and after rebuild, when the sops secret is available.
    system.activationScripts.github-token-nix = ''
      TOKEN_FILE="${cfg.secretPath}"
      NIX_CONF="/etc/nix/nix.conf"

      if [ -r "$TOKEN_FILE" ]; then
        TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')
        # Remove old github.com line if present
        ${pkgs.gnused}/bin/sed -i '/^access-tokens = github.com=/d' "$NIX_CONF" 2>/dev/null || true
        # Append new token
        echo "access-tokens = github.com=$TOKEN" >> "$NIX_CONF"
      fi
    '';
  };
}
