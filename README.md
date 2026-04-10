# ft-nixos

A modular NixOS configuration using flakes, Home Manager, and NVF (Nix Vim Framework).

---

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Design Philosophy](#design-philosophy)
4. [Getting Started](#getting-started)
5. [Module System](#module-system)
6. [Neovim Setup (NVF)](#neovim-setup-nvf)
7. [Troubleshooting](#troubleshooting)
8. [Future Plans](#future-plans)

---

## Overview

This repository contains a personal NixOS configuration with the following goals:

- **Modular**: Reusable configs across multiple machines
- **Custom options**: Clean `ft.*` namespace for toggling features
- **Separation of concerns**: System config vs. user config vs. program modules
- **Modern tooling**: NVF for Neovim, Home Manager for user environment

---

## Repository Structure

```
.
├── flake.nix                    # Entry point - defines inputs/outputs
├── flake.lock                   # Locked dependency versions
│
├── hosts/                       # Machine-specific configurations
│   └── laptop/
│       ├── configuration.nix    # Host system config (boot, users, ft.* options)
│       ├── hardware-configuration.nix  # Auto-generated hardware config
│       └── home.nix             # Home Manager setup for this host
│
├── modules/                     # NixOS system modules (ft.* options)
│   ├── default.nix              # Aggregates all system modules
│   ├── core/                    # Essential system settings
│   │   ├── default.nix
│   │   ├── base.nix             # Boot, timezone, networking, SSH
│   │   └── packages.nix         # Core system packages (curl, htop, fastfetch)
│   └── programs/                # Program modules (system-level)
│       ├── default.nix
│       ├── git.nix              # Git system config (ft.programs.git)
│       └── zsh.nix              # Zsh system config (ft.programs.zsh)
│
└── home/                        # Home Manager configuration
    ├── default.nix              # Entry point (username, imports)
    └── features/                # User-level features
        ├── default.nix          # Aggregates all home features
        ├── git.nix              # Git user identity (name, email)
        └── nvim/                # Neovim (NVF) configuration
            ├── default.nix      # NVF module import
            └── settings.nix     # NVF settings (plugins, keymaps, etc.)
```

---

## Design Philosophy

### Custom Module System (`ft.*`)

System-level features use a custom namespace for clean toggling:

```nix
# In hosts/laptop/configuration.nix
{
  ft.programs.git.enable = true;
  ft.programs.zsh.enable = true;
}
```

**Benefits:**
- Clean feature toggles
- Reusable across hosts
- Self-documenting

### Separation of Concerns

| Layer | Location | Responsibility |
|-------|----------|----------------|
| System | `hosts/<host>/` | Machine-specific: hardware, users, hostname |
| Modules | `modules/` | Reusable system modules with `ft.*` options |
| User | `home/` | Home Manager: dotfiles, user programs, shell config |

### Git Configuration Split

Git is configured at two levels:

1. **System** (`modules/programs/git.nix`): Enables Git, LFS support, installs package
2. **User** (`home/features/git.nix`): Personal identity (name, email)

This allows Git to be available system-wide while keeping personal settings in Home Manager.

---

## Getting Started

### Prerequisites

- NixOS with flakes enabled
- This repo at `/etc/nixos` (or elsewhere)

### Rebuild

```bash
sudo nixos-rebuild switch --flake /etc/nixos#laptop
```

### Update

```bash
nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#laptop
```

---

## Module System

### Adding a New Host

1. Create `hosts/<hostname>/`
2. Copy `hardware-configuration.nix` from the machine
3. Create `configuration.nix`:

```nix
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "my-host";

  users.users.myuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  ft.programs.git.enable = true;
  ft.programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
```

4. Create `home.nix`:

```nix
{ inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.myuser = import ../../home;
}
```

5. Add to `flake.nix`:

```nix
nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/my-host/configuration.nix
    home-manager.nixosModules.home-manager
  ];
};
```

### Creating a New `ft.*` Module

`modules/programs/myapp.nix`:

```nix
{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.myapp;
in
{
  options.ft.programs.myapp = {
    enable = lib.mkEnableOption "MyApp";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.myapp ];
  };
}
```

Import in `modules/programs/default.nix`.

---

## Neovim Setup (NVF)

Uses **NVF (Nix Vim Framework)** for declarative Neovim configuration.

### Current Setup

Located in `home/features/nvim/`:

- **Theme**: Gruvbox Dark
- **Plugins**: Telescope, Lualine, Gitsigns, nvim-cmp
- **Languages**: Nix, Markdown, Bash (LSP, treesitter, formatting)
- **Keymaps**: Custom bindings for save (`<C-s>`), delete line (`<C-k>`), etc.

### Important Notes

- NVF is **Home Manager-based**, not a system package
- Do NOT use `programs.neovim.enable = true` alongside NVF
- Do NOT install `pkgs.neovim` manually

---

## Troubleshooting

### `nvim` not found

Ensure `inputs.nvf.homeManagerModules.default` is imported in your home config.

### Git "dubious ownership"

```bash
sudo chown -R $(whoami):users /etc/nixos
```

### Keyboard layout reset

```nix
console.keyMap = "de";
```

---

## Future Plans

- [ ] Move repo from `/etc/nixos` to `~/projects/ft-nixos`
- [ ] Add multiple host profiles (desktop, server, minimal)
- [ ] Integrate Stylix for unified theming
- [ ] Add Hyprland/Wayland setup
- [ ] Expand NVF config
- [ ] Secrets management (agenix or sops-nix)

---

## Author

Fynn Mahringer  
HTL Steyr – IT
