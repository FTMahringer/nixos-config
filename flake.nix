{
  description = "Ft-Nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modular flake structure - cleaner organization
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
    };

    # FT-nixforge unified package registry
    ft-nixpkgs = {
      url = "github:FT-nixforge/ft-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.54.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AI coding agents
    kimi-cli = {
      url = "github:MoonshotAI/kimi-cli/1.31.0";
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
          # FT-nixforge theming + launcher
          inputs.ft-nixpkgs.nixosModules.ft-nixpalette
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            # ft-nixpalette homeModules import stylix.homeModules.stylix.
            # Disable auto-import to prevent double-loading.
            stylix.homeManagerIntegration.autoImport = false;
            home-manager.sharedModules = [
              inputs.ft-nixpkgs.homeModules.ft-nixlaunch
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
