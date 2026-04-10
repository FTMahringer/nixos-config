{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.ft.security.sops;
in
{
  options.ft.security.sops = {
    enable = lib.mkEnableOption "SOPS secrets management";

    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sops/age/keys.txt";
      description = "Path to the age private key for decrypting secrets.";
    };

    defaultSopsFile = lib.mkOption {
      type = lib.types.str;
      default = "./secrets/secrets.yaml";
      description = "Default sops file to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      # Age private key for decryption
      age.keyFile = cfg.ageKeyFile;

      # Default secrets file
      defaultSopsFile = cfg.defaultSopsFile;

      # Example secrets (uncomment and modify as needed)
      # secrets.ssh_private_key = {
      #   owner = config.users.users.fynn.name;
      #   group = config.users.users.fynn.group;
      #   mode = "0600";
      #   path = "/home/fynn/.ssh/id_ed25519";
      # };

      # secrets."passwords/fynn" = {
      #   neededForUsers = true;
      # };
    };

    # Ensure the sops directory exists
    system.activationScripts.sops-dir = ''
      mkdir -p /var/lib/sops/age
      chmod 700 /var/lib/sops/age
    '';

    # Install sops for manual secret management
    environment.systemPackages = [ pkgs.sops ];
  };
}
