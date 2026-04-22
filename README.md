# ft-nixos

A modular NixOS configuration using flakes, Home Manager, and NVF.

> **Full documentation:** [FT-nixforge Community Docs](https://ft-nixforge.github.io/community/docs/nixos-config)

---

## Quick Start

```bash
# Clone
sudo git clone https://github.com/FT-nixforge/ft-nixos /etc/nixos

# Rebuild
sudo nixos-rebuild switch --flake /etc/nixos#laptop

# Or use the alias (after rebuild)
rebuild
```

## What's Inside

| Layer | Location | Purpose |
|-------|----------|---------|
| **Hosts** | `hosts/<host>/` | Machine-specific config (hardware, users) |
| **Modules** | `modules/` | Reusable NixOS modules (`ft.*` options) |
| **Home** | `home/` | Home Manager: dotfiles, shells, editors |
| **Flakes** | `flake.nix` | All inputs locked in `flake.lock` |

## Key Features

- **Desktop:** Hyprland or Mango/Wayfire (`ft.desktop.compositor = "hyprland"`)
- **Editor:** Neovim (NVF) + Zed (`nvim-z` opens Zed)
- **Shell:** Zsh (default) + Fish, shared aliases & tools
- **Theming:** ft-nixpalette → Stylix (base16, auto-switchable)
- **Launcher:** ft-nixprism (Stylix-themed, `SUPER+Space`)
- **Home Dir:** Structured layout (`~/projects/`, `~/documents/`, etc.)

## Structure

```
.
├── flake.nix
├── hosts/
│   └── laptop/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── modules/
│   ├── core/          # Boot, networking, base packages
│   ├── programs/      # Git, Zsh, Zed, Hyprland
│   ├── security/      # sops-nix
│   ├── system/        # Impermanence
│   └── theming/       # ft-nixpalette + Stylix
└── home/
    └── features/
        ├── desktop/   # Hyprland, Mango, shared (bar, lock, etc.)
        ├── nvim/      # NVF config
        ├── shell/     # Zsh, Fish, shared tools
        ├── terminal/  # Kitty, WezTerm
        └── home-dir/  # Structured ~/ layout
```

## Useful Aliases

```bash
rebuild      # sudo nixos-rebuild switch --flake /etc/nixos#laptop
update       # nix flake update + rebuild
nvim-z       # Open Zed in current directory
ll, lt, cat  # eza, bat replacements
```

## Docs & Community

- **Full docs:** [ft-nixforge.github.io/community](https://ft-nixforge.github.io/community)
- **Flakes:** [github.com/FT-nixforge](https://github.com/FT-nixforge)
- **Issues/Discussions:** [FT-nixforge/community](https://github.com/FT-nixforge/community)

---

*Fynn Mahringer — HTL Steyr IT*
