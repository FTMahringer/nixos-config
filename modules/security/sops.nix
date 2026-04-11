{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.ft.security.sops;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.ft.security.sops = {
    enable = lib.mkEnableOption "SOPS secrets management";

    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sops/age/keys.txt";
      description = "Path to the age private key for decrypting secrets.";
    };

    secretsFile = lib.mkOption {
      type = lib.types.path;
      default = ../../secrets/secrets.yaml;
      description = "Path to the encrypted SOPS secrets file.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = cfg.ageKeyFile;

      defaultSopsFile = cfg.secretsFile;

      secrets.ssh_private_key = {
        owner = config.users.users.fynn.name;
        group = config.users.users.fynn.group;
        mode = "0600";
        path = "/home/fynn/.ssh/id_ed25519";
      };

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
