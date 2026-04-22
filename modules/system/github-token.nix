{ config, lib, pkgs, ... }:

let
  cfg = config.ft.system.github-token;

  # Script to validate token format and warn if it looks like an SSH key
  tokenCheckScript = pkgs.writeShellScriptBin "check-github-token" ''
    TOKEN_FILE="${cfg.secretPath}"
    if [ -r "$TOKEN_FILE" ]; then
      TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')
      if echo "$TOKEN" | grep -qE '^ssh-(ed25519|rsa|ecdsa|dsa)\s|^-----BEGIN'; then
        echo "WARNING: The value in $TOKEN_FILE looks like an SSH key, not a GitHub PAT." >&2
        echo "SSH keys work for git operations but NOT for the GitHub API that Nix uses." >&2
        echo "Please create a GitHub Personal Access Token at:" >&2
        echo "  https://github.com/settings/tokens" >&2
        echo "Store it in your secrets.yaml under api_tokens/github" >&2
        exit 1
      elif echo "$TOKEN" | grep -qE '^ghp_|^github_pat_'; then
        echo "OK: GitHub PAT detected (format looks correct)"
        exit 0
      else
        echo "WARNING: Token format unrecognized. Expected ghp_... or github_pat_..." >&2
        echo "Token starts with: $(echo "$TOKEN" | head -c 20)..." >&2
        exit 1
      fi
    else
      echo "WARNING: Token file $TOKEN_FILE not found or not readable" >&2
      exit 1
    fi
  '';
in
{
  options.ft.system.github-token = {
    enable = lib.mkEnableOption ''
      GitHub access token for Nix flake updates.

      IMPORTANT: This requires a GitHub Personal Access Token (PAT), NOT an SSH key.
      The SSH key (configured via ft.security.sops secrets.ssh_private_key) is used
      for git operations (git clone/push), but Nix flakes use the GitHub REST API
      to resolve commit hashes, which requires a PAT.

      Create a PAT at: https://github.com/settings/tokens
      Required scope: none for public repos (just raises rate limits from 60 to 5000/hr)
      For private flakes: 'repo' scope needed

      Store the token in your secrets.yaml under the key 'api_tokens/github'.
      Format: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (classic)
           or github_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (fine-grained)
    '';

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
    # Make the check script available
    environment.systemPackages = [ tokenCheckScript ];

    # Write the GitHub token into the user's nix.conf.
    # The user-level config is read by the Nix client and takes effect
    # immediately without requiring a daemon restart.
    system.activationScripts.github-token-user = lib.mkAfter
      ''
        TOKEN_FILE="${cfg.secretPath}"
        USER_HOME="/home/${cfg.user}"
        NIX_USER_CONF="$USER_HOME/.config/nix/nix.conf"
        NIX_USER_DIR="$USER_HOME/.config/nix"

        mkdir -p "$NIX_USER_DIR"
        chown ${cfg.user}:users "$NIX_USER_DIR" 2>/dev/null || true

        if [ -r "$TOKEN_FILE" ]; then
          TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')

          # Validate token format
          if echo "$TOKEN" | grep -qE '^ssh-(ed25519|rsa|ecdsa|dsa)\s|^-----BEGIN'; then
            echo "github-token-user: WARNING - The token looks like an SSH key, not a GitHub PAT." >&2
            echo "  SSH keys do NOT work for GitHub API rate limits." >&2
            echo "  Create a PAT at https://github.com/settings/tokens" >&2
          fi

          # Remove old token line if present
          if [ -f "$NIX_USER_CONF" ]; then
            ${pkgs.gnused}/bin/sed -i '/^access-tokens = github.com=/d' "$NIX_USER_CONF" 2>/dev/null || true
          fi

          # Write new token
          echo "access-tokens = github.com=$TOKEN" >> "$NIX_USER_CONF"
          chown ${cfg.user}:users "$NIX_USER_CONF" 2>/dev/null || true
          chmod 600 "$NIX_USER_CONF" 2>/dev/null || true
          echo "github-token-user: GitHub token written to $NIX_USER_CONF"
        else
          echo "github-token-user: WARNING - Token file $TOKEN_FILE not found" >&2
        fi
      '';

    # Also write to system nix.conf for the daemon.
    system.activationScripts.github-token-system = lib.mkAfter
      ''
        TOKEN_FILE="${cfg.secretPath}"
        TOKEN_DIR="/etc/nix/secrets"
        TOKEN_CONF="$TOKEN_DIR/access-tokens.conf"
        NIX_CONF="/etc/nix/nix.conf"

        mkdir -p "$TOKEN_DIR"
        chmod 755 "$TOKEN_DIR"

        if [ -r "$TOKEN_FILE" ]; then
          TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')
          # Write token to restricted file
          echo "access-tokens = github.com=$TOKEN" > "$TOKEN_CONF"
          chmod 600 "$TOKEN_CONF"

          # Ensure the include directive is present in nix.conf
          if ! grep -qF '!include /etc/nix/secrets/access-tokens.conf' "$NIX_CONF" 2>/dev/null; then
            echo "" >> "$NIX_CONF"
            echo "# Include GitHub access token (managed by sops-nix)" >> "$NIX_CONF"
            echo "!include /etc/nix/secrets/access-tokens.conf" >> "$NIX_CONF"
          fi
          echo "github-token-system: GitHub token written to $TOKEN_CONF"
        else
          # Token file not available yet - write placeholder to prevent errors
          echo "# GitHub token not yet available" > "$TOKEN_CONF"
          chmod 600 "$TOKEN_CONF"
        fi
      '';
  };
}
