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

    user = lib.mkOption {
      type = lib.types.str;
      default = "fynn";
      description = "User for whom to configure the GitHub token in ~/.config/nix/nix.conf";
    };
  };

  config = lib.mkIf cfg.enable {
    # Write the GitHub token into the user's nix.conf.
    # The user-level config is read by the Nix client and takes effect
    # immediately without requiring a daemon restart.
    # This is needed for 'nix flake update' and other client commands
    # that hit the GitHub API directly.
    system.activationScripts.github-token-user = lib.mkAfter ''
      TOKEN_FILE="${cfg.secretPath}"
      USER_HOME="/home/${cfg.user}"
      NIX_USER_CONF="$USER_HOME/.config/nix/nix.conf"
      NIX_USER_DIR="$USER_HOME/.config/nix"

      mkdir -p "$NIX_USER_DIR"
      chown ${cfg.user}:users "$NIX_USER_DIR" 2>/dev/null || true

      if [ -r "$TOKEN_FILE" ]; then
        TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')

        # Remove old token line if present
        if [ -f "$NIX_USER_CONF" ]; then
          ${pkgs.gnused}/bin/sed -i '/^extra-access-tokens = github.com=/d' "$NIX_USER_CONF" 2>/dev/null || true
        fi

        # Write new token
        echo "extra-access-tokens = github.com=$TOKEN" >> "$NIX_USER_CONF"
        chown ${cfg.user}:users "$NIX_USER_CONF" 2>/dev/null || true
        chmod 600 "$NIX_USER_CONF" 2>/dev/null || true
      fi
    '';

    # Also write to system nix.conf for the daemon.
    # Uses a separate included file with restricted permissions.
    system.activationScripts.github-token-system = lib.mkAfter ''
      TOKEN_FILE="${cfg.secretPath}"
      TOKEN_DIR="/etc/nix/secrets"
      TOKEN_CONF="$TOKEN_DIR/extra-access-tokens.conf"
      NIX_CONF="/etc/nix/nix.conf"

      mkdir -p "$TOKEN_DIR"
      chmod 755 "$TOKEN_DIR"

      if [ -r "$TOKEN_FILE" ]; then
        TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')
        # Write token to restricted file
        echo "extra-access-tokens = github.com=$TOKEN" > "$TOKEN_CONF"
        chmod 600 "$TOKEN_CONF"

        # Ensure the include directive is present in nix.conf
        if ! grep -qF '!include /etc/nix/secrets/extra-access-tokens.conf' "$NIX_CONF" 2>/dev/null; then
          echo '' >> "$NIX_CONF"
          echo '# Include GitHub access token (managed by sops-nix)' >> "$NIX_CONF"
          echo '!include /etc/nix/secrets/extra-access-tokens.conf' >> "$NIX_CONF"
        fi
      else
        # Token file not available yet - write placeholder to prevent errors
        echo "# GitHub token not yet available" > "$TOKEN_CONF"
        chmod 600 "$TOKEN_CONF"
      fi
    '';
  };
}
