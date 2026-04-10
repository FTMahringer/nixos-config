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
│   ├── programs/                # Program modules (system-level)
│   │   ├── default.nix
│   │   ├── git.nix              # Git system config (ft.programs.git)
│   │   └── zsh.nix              # Zsh system config (ft.programs.zsh)
│   ├── security/                # Security modules
│   │   ├── default.nix
│   │   └── sops.nix             # Secrets management (ft.security.sops)
│   └── system/                  # System-level features
│       ├── default.nix
│       └── impermanence.nix     # Ephemeral root (ft.system.impermanence)
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

## Development Tools

This configuration includes several flakes to improve the development workflow:

| Tool | Purpose | Command |
|------|---------|---------|
| **treefmt-nix** | Format all code | `nix fmt` |
| **git-hooks.nix** | Pre-commit checks | `nix flake check` |
| **nix-your-shell** | Keep zsh in nix shell | Automatic |
| **sops-nix** | Secrets management | See [Secrets](#secrets-management) |
| **impermanence** | Ephemeral root | See [Impermanence](#impermanence) |

### Testing in a VM

Before deploying to hardware, test changes in a VM:

```bash
nixos-rebuild build-vm --flake .#laptop-vm
./result/bin/run-nixos-vm
```

Login with `fynn` / `vm`.

### Formatting Code

```bash
nix fmt        # Format all Nix, shell, and markdown files
```

### Pre-commit Checks

```bash
nix flake check    # Run statix (lint) and deadnix (dead code detection)
```

### nix-your-shell

When you run `nix shell nixpkgs#somepackage`, you normally lose your zsh configuration. With `nix-your-shell`, you stay in zsh with all your settings.

---

## Secrets Management (sops-nix)

Secrets are encrypted with [SOPS](https://github.com/getsops/sops) and decrypted at build time.

### Setup

1. **Generate an age key**:
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

2. **Get your public key**:
   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt
   # Outputs: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

3. **Edit `secrets/.sops.yaml`** - replace `YOUR_AGE_PUBLIC_KEY_HERE` with your key

4. **Create and encrypt secrets**:
   ```bash
   cp secrets/secrets.example.yaml secrets/secrets.yaml
   # Edit secrets.yaml with your actual secrets
   sops secrets/secrets.yaml  # Encrypts the file
   ```

5. **Enable in your host config**:
   ```nix
   ft.security.sops.enable = true;
   ```

6. **Copy the age key to your NixOS system**:
   ```bash
   sudo mkdir -p /var/lib/sops/age
   sudo cp ~/.config/sops/age/keys.txt /var/lib/sops/age/
   sudo chmod 700 /var/lib/sops/age
   sudo chmod 600 /var/lib/sops/age/keys.txt
   ```

### Usage in Config

```nix
# Access a secret
config.sops.secrets.my_password.path
```

---

## Impermanence

[Impermanence](https://github.com/nix-community/impermanence) makes your root filesystem ephemeral - it resets on every boot. Only `/persist` and `/home` are kept.

### Prerequisites

- A separate partition labeled `persist` mounted at `/persist`
- Backups! This is destructive if misconfigured

### Setup

1. **Create a persist partition** (ext4, labeled "persist")

2. **Enable in your host config**:
   ```nix
   ft.system.impermanence.enable = true;
   ft.system.impermanence.directories = [
     "/var/lib/bluetooth"  # Keep Bluetooth pairings
   ];
   ```

3. **Add home persistence** in `home/default.nix`:
   ```nix
   imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
   
   home.persistence."/persist/home/fynn" = {
     directories = [
       "Documents"
       "Downloads"
       ".ssh"
       ".local/share"
     ];
   };
   ```

### Benefits

- **Clean system** on every boot
- **No state accumulation**
- **Easy rollback** - reboot fixes most issues
- **Forces good habits** - config must be in git

---

## Future Plans

- [ ] Move repo from `/etc/nixos` to `~/projects/ft-nixos`
- [ ] Add multiple host profiles (desktop, server, minimal)
- [ ] Integrate Stylix for unified theming
- [ ] Add Hyprland/Wayland setup
- [ ] Expand NVF config

---

## Author

Fynn Mahringer  
HTL Steyr – IT
