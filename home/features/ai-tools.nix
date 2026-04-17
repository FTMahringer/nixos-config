{ config, lib, pkgs, inputs, ... }:

{
  # AI coding agents packages
  home.packages = [
    # Kimi CLI - from flake input (supports ACP via `kimi acp`)
    inputs.kimi-cli.packages.${pkgs.stdenv.hostPlatform.system}.default

    # OpenCode - from nixpkgs (supports ACP via `opencode acp`)
    pkgs.opencode
  ];

  # Kimi CLI configuration
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

  # OpenCode configuration
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
    OPENCODE_THEME = "system";
  };
}
