{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
      ../../modules
    ];

  networking.hostName = "ft-nixos";

  users.users.fynn = {
    isNormalUser = true;
    description = "Fynn";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Enable core programs
  ft.programs.git.enable = true;
  ft.programs.zsh.enable = true;

  # Theming (Stylix) — change scheme here to retheme everything
  ft.theming.enable = true;
  # ft.theming.scheme = "catppuccin-mocha";   # override default (gruvbox-dark-medium)
  # ft.theming.polarity = "dark";
  # ft.theming.wallpaper = ../../assets/wallpapers/my-wallpaper.png;

  # --- OPTIONAL: Secrets Management (sops-nix) ---
  # 1. Generate age key: mkdir -p ~/.config/sops/age && age-keygen -o ~/.config/sops/age/keys.txt
  # 2. Copy public key to secrets/.sops.yaml
  # 3. Create secrets/secrets.yaml and encrypt with: sops secrets/secrets.yaml
  # 4. Uncomment below:
  # ft.security.sops.enable = true;

  # --- OPTIONAL: Impermanence (ephemeral root) ---
  # WARNING: This requires a separate "persist" partition!
  # 1. Create a partition labeled "persist"
  # 2. Uncomment below:
  # ft.system.impermanence.enable = true;
  # ft.system.impermanence.directories = [
  #   "/var/lib/bluetooth"    # Bluetooth pairings
  # ];

  system.stateVersion = "25.11";
}
