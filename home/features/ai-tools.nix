{ config, lib, pkgs, inputs, ... }:

let
  # nixpalette → Stylix base16 colors
  c = config.lib.stylix.colors;
in
{
  # AI coding agents packages
  home.packages = [
    # Kimi CLI - from flake input
    inputs.kimi-cli.packages.${pkgs.stdenv.hostPlatform.system}.default

    # OpenCode - from nixpkgs
    pkgs.opencode
  ];

  # Kimi CLI configuration with nixpalette colors
  # Config location: ~/.kimi/config.toml
  home.file.".kimi/config.toml".text = lib.mkDefault ''
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
    # NOTE: api_key must be set here or via KIMI_API_KEY environment variable
    # Leave empty to use /login command (OAuth) - kimi will populate this after login
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
  '';

  # OpenCode configuration with nixpalette theming
  # Config location: ~/.opencode/config.json
  home.file.".opencode/config.json".text = lib.mkDefault ''
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
  '';

  # OpenCode TUI configuration
  home.file.".opencode/tui.json".text = lib.mkDefault ''
    {
      "$schema": "https://opencode.ai/tui.json",
      "plugin": []
    }
  '';

  # OpenCode theme override using environment variables for terminal colors
  # OpenCode respects terminal colors, so nixpalette/stylix terminal theming will apply
  home.sessionVariables = {
    # Ensure OpenCode uses terminal colors (which are themed by nixpalette)
    OPENCODE_THEME = "system";
  };
}
