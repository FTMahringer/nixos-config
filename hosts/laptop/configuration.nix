{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
      ../../modules
    ];

  # Allow unfree packages (Obsidian, Spotify, etc.)
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "ft-nixos";

  users.users.fynn = {
    isNormalUser = true;
    description = "Fynn";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Enable core programs
  ft.programs.git.enable = true;
  ft.programs.zsh.enable = true;

  # Hyprland Wayland compositor (enables greetd, pipewire, polkit, portals)
  ft.programs.hyprland.enable = true;

  # Theming (nixpalette → Stylix) — change theme here to retheme everything.
  # Theme IDs:  "builtin:base/<name>"  |  "user:base/<name>"  |  "user:derived/<name>"
  # Built-ins: catppuccin-mocha, nord
  # See assets/themes/ for user themes you can add.
  ft.theming.enable = true;
  ft.theming.theme = "builtin:base/catppuccin-mocha";
  ft.theming.userThemeDir = ../../assets/themes;

  # Boot-menu specialisations — each generates an alternate system config.
  # Switch at boot or via: nixos-rebuild switch --specialisation <name>
  ft.theming.specialisations = {
    nord    = "builtin:base/nord";
    gruvbox = "user:base/gruvbox";
  };

  # --- OPTIONAL: Secrets Management (sops-nix) ---
  # 1. Generate age key: mkdir -p ~/.config/sops/age && age-keygen -o ~/.config/sops/age/keys.txt
  # 2. Copy public key to secrets/.sops.yaml
  # 3. Create secrets/secrets.yaml and encrypt with: sops secrets/secrets.yaml
  # 4. Uncomment below:
  ft.security.sops.enable = true;

  # --- OPTIONAL: Impermanence (ephemeral root) ---
  # WARNING: This requires a separate "persist" partition!
  # 1. Create a partition labeled "persist"
  # 2. Uncomment below:
  # ft.system.impermanence.enable = true;
  # ft.system.impermanence.directories = [
  #   "/var/lib/bluetooth"    # Bluetooth pairings
  # ];

  # --- Automatic NixOS Generation Cleanup ---
  # Delete generations older than 7 days to keep boot menu clean and save disk space
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Also optimize the nix store (deduplicate) weekly
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # --- Docker ---
  virtualisation.docker.enable = true;
  users.users.fynn.extraGroups = [ "wheel" "networkmanager" "docker" ];

  system.stateVersion = "25.11";
}
