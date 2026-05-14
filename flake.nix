{
  description = "Ft-Nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unified formatting for all files
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit hooks for quality checks
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep your shell when using nix shell
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence - ephemeral root
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FT-nixforge unified package registry
    ft-nixpkgs = {
      url = "github:FT-nixforge/ft-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # caelestia-shell = {
    #   url = "github:caelestia-dots/shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # AI coding agents
    kimi-cli = {
      url = "github:MoonshotAI/kimi-cli/1.31.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ft-nixpkgs, ... }: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          # FT-nixforge theming (NixOS module â€” system-wide Stylix + DE integration)
          # ft-nixpalette is NixOS-only. Stylix auto-propagates to HM users
          # via stylix.homeManagerIntegration (default: true).
          inputs.ft-nixpkgs.nixosModules.ft-nixpalette
          inputs.mango.nixosModules.mango

          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              inputs.ft-nixpkgs.homeModules.ft-nixlaunch
              inputs.mango.hmModules.mango
            ];
          }
        ];
      };
    };

    # Formatter for all files - run: nix fmt
    formatter.x86_64-linux = (inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.x86_64-linux {
      projectRootFile = "flake.nix";
      programs.nixpkgs-fmt.enable = true;  # Nix formatter
      programs.shfmt.enable = true;        # Shell formatter
      programs.prettier.enable = true;     # JSON, Markdown, etc.
    }).config.build.wrapper;

    # Pre-commit hooks - run: nix flake check
    checks.x86_64-linux = {
      pre-commit = inputs.git-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          nixpkgs-fmt.enable = true;  # Format Nix files
          statix.enable = true;       # Lint Nix files
          deadnix.enable = true;      # Find dead Nix code
        };
      };
    };
  };
}
