{ config, lib, pkgs, inputs, ... }:

let
  # nixpalette → Stylix base16 colors
  c = config.lib.stylix.colors;

  # Wrapper for kimi to ensure it has proper environment
  kimiWrapper = pkgs.writeShellScriptBin "kimi-zed" ''
    # Ensure node and other tools are in PATH for Zed integration
    export PATH="${pkgs.nodejs}/bin:$HOME/.npm-packages/bin:$PATH"
    exec ${inputs.kimi-cli.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/kimi "$@"
  '';

  # Wrapper for opencode to ensure it has proper environment
  opencodeWrapper = pkgs.writeShellScriptBin "opencode-zed" ''
    # Ensure node and other tools are in PATH for Zed integration
    export PATH="${pkgs.nodejs}/bin:$HOME/.npm-packages/bin:$PATH"
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
in
{
  # AI coding agents packages
  home.packages = [
    # Kimi CLI - from flake input
    inputs.kimi-cli.packages.${pkgs.stdenv.hostPlatform.system}.default

    # OpenCode - from nixpkgs
    pkgs.opencode

    # Wrappers for Zed integration
    kimiWrapper
    opencodeWrapper

    # --- OPTIONAL: ACP (Agent Client Protocol) tools for Zed ---
    # These are needed for Zed's agent_servers to work (see settings/zed-settings.json)
    # Uncomment to install, or install manually via npm:
    #
    pkgs.nodePackages."@github/copilot-cli"  # GitHub Copilot CLI (if available)

    # Or install manually: npm install -g @github/copilot-cli
  ];

  # Ensure AI tools are available in PATH for GUI apps (like Zed)
  # Zed spawns processes with a limited environment, so we need to ensure
  # the tools are in a location that's always accessible
  home.file.".local/bin/kimi".source = lib.mkForce "${inputs.kimi-cli.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/kimi";
  home.file.".local/bin/opencode".source = lib.mkForce "${pkgs.opencode}/bin/opencode";

  # Add ~/.local/bin to PATH
  home.sessionPath = lib.mkBefore [ "$HOME/.local/bin" ];

  # Kimi CLI configuration with nixpalette colors
  # Config location: ~/.kimi/config.toml
  # Initial config - copied once and left writable so kimi can save API key after login
  home.activation.kimiConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Create Kimi config directory if it doesn't exist
    mkdir -p "$HOME/.kimi"

    # Copy config.toml only if it doesn't exist (preserves API key after login)
    if [ ! -f "$HOME/.kimi/config.toml" ]; then
      cat > "$HOME/.kimi/config.toml" << 'EOF'
default_model = "kimi-for-coding"
default_thinking = false
default_yolo = false
default_plan_mode = false
default_editor = "nvim"
theme = "dark"
merge_all_available_skills = false

[providers.kimi-for-coding]
type = "kimi"
base_url = "https://api.kimi.com/coding/v1"
# NOTE: api_key will be populated after /login command
api_key = ""

[models.kimi-for-coding]
provider = "kimi-for-coding"
model = "kimi-for-coding"
max_context_size = 262144

[loop_control]
max_steps_per_turn = 100
max_retries_per_step = 3
max_ralph_iterations = 0
reserved_context_size = 50000
compaction_trigger_ratio = 0.85

[background]
max_running_tasks = 4
keep_alive_on_exit = false
agent_task_timeout_s = 900

[mcp.client]
tool_call_timeout_ms = 60000
EOF
      chmod 644 "$HOME/.kimi/config.toml"
    fi
  '';

  # OpenCode configuration with nixpalette theming
  # Config location: ~/.opencode/config.json
  # Initial config - copied once and left writable
  home.activation.opencodeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Create OpenCode config directory if it doesn't exist
    mkdir -p "$HOME/.opencode"

    # Copy config.json only if it doesn't exist
    if [ ! -f "$HOME/.opencode/config.json" ]; then
      cat > "$HOME/.opencode/config.json" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "opencode": {
      "options": {}
    }
  },
  "permission": {},
  "mcp": {},
  "tools": {}
}
EOF
      chmod 644 "$HOME/.opencode/config.json"
    fi

    # Copy tui.json only if it doesn't exist
    if [ ! -f "$HOME/.opencode/tui.json" ]; then
      cat > "$HOME/.opencode/tui.json" << 'EOF'
{
  "$schema": "https://opencode.ai/tui.json",
  "plugin": []
}
EOF
      chmod 644 "$HOME/.opencode/tui.json"
    fi
  '';

  # OpenCode theme override using environment variables for terminal colors
  # OpenCode respects terminal colors, so nixpalette/stylix terminal theming will apply
  home.sessionVariables = {
    # Ensure OpenCode uses terminal colors (which are themed by nixpalette)
    OPENCODE_THEME = "system";
  };

  # --- ACP Tools Installation Helper ---
  # Script to install ACP tools for Zed when needed
  home.file.".local/bin/install-zed-acp-tools" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Install ACP (Agent Client Protocol) tools for Zed
      # These are required for Zed's agent_servers to work

      set -e

      echo "Installing ACP tools for Zed..."

      # Ensure npm global directory exists
      mkdir -p "$HOME/.npm-packages"

      # Install GitHub Copilot CLI
      echo "Installing GitHub Copilot CLI..."
      npm install -g @github/copilot-cli || echo "Failed to install GitHub Copilot CLI (may require auth)"

      # Install other ACP tools if available
      # Note: Some ACP tools may not be publicly available or may require specific installation

      echo ""
      echo "ACP tools installation complete!"
      echo "Note: Some tools may require additional authentication:"
      echo "  - GitHub Copilot: Run 'gh auth login' and 'gh copilot auth'"
      echo "  - Other tools: Check their respective documentation"
    '';
  };
}
